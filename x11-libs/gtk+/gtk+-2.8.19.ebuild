# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-2.8.19.ebuild,v 1.4 2006/07/10 17:52:43 gustavoz Exp $

inherit gnome.org flag-o-matic eutils debug autotools virtualx

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh sparc ~x86 ~x86-fbsd"
IUSE="debug doc jpeg tiff xinerama"

RDEPEND="|| ( (
			x11-libs/libXrender
			x11-libs/libX11
			x11-libs/libXi
			x11-libs/libXt
			x11-libs/libXext
			x11-libs/libXcursor
			x11-libs/libXrandr
			x11-libs/libXfixes
			xinerama? ( x11-libs/libXinerama ) )
		virtual/x11 )
	>=dev-libs/glib-2.10.1
	>=x11-libs/pango-1.9
	>=dev-libs/atk-1.10.1
	>=x11-libs/cairo-0.9.2
	media-libs/fontconfig
	x11-misc/shared-mime-info
	>=media-libs/libpng-1.2.1
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( >=media-libs/tiff-3.5.7 )"

DEPEND="${RDEPEND}
	sys-devel/autoconf
	>=dev-util/pkgconfig-0.9
	=sys-devel/automake-1.7*
	|| ( (
			x11-proto/xextproto
			x11-proto/xproto
			x11-proto/inputproto
			x11-proto/xineramaproto )
		virtual/x11 )
	doc? (
		>=dev-util/gtk-doc-1.4
		~app-text/docbook-xml-dtd-4.1.2 )"

RESTRICT="confcache"


pkg_setup() {

	if ! built_with_use x11-libs/cairo X; then
		einfo "Please re-emerge x11-libs/cairo with the X USE flag set"
		die "cairo needs the X flag set"
	fi

}

set_gtk2_confdir() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	use x86 && [ "$(get_libdir)" == "lib32" ] && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0}
}

src_unpack() {

	unpack ${A}
	cd "${S}"

	# Optionalize xinerama support
	epatch "${FILESDIR}"/${PN}-2.8.10-xinerama.patch

	# use an arch-specific config directory so that 32bit and 64bit versions
	# dont clash on multilib systems
	has_multilib_profile && epatch "${FILESDIR}"/${PN}-2.8.0-multilib.patch

	# and this line is just here to make building emul-linux-x86-gtklibs a bit
	# easier, so even this should be amd64 specific.
	if use x86 && [ "$(get_libdir)" == "lib32" ]; then
		epatch "${FILESDIR}"/${PN}-2.8.0-multilib.patch
	fi

	use ppc64 && append-flags -mminimal-toc

	# remember, eautoreconf applies elibtoolize.
	# if you remove this, you should manually run elibtoolize
	export WANT_AUTOMAKE=1.7
	cp aclocal.m4 old_macros.m4
	AT_M4DIR="."
	eautoreconf

	epunt_cxx

}

src_compile() {

	# png always on to display icons (foser)
	local myconf="$(use_enable doc gtk-doc) \
		$(use_with jpeg libjpeg) \
		$(use_with tiff libtiff) \
		$(use_enable xinerama) \
		--with-libpng \
		--with-gdktarget=x11 \
		--with-xinput"

	# Passing --disable-debug is not recommended for production use
	use debug && myconf="${myconf} --enable-debug=yes"

	econf ${myconf} || die "./configure failed to run"

	emake || die "gtk+ failed to compile"
}

src_test() {

	Xmake check || die

}

src_install() {

	make DESTDIR="${D}" install || die "Installation failed"

	set_gtk2_confdir
	dodir ${GTK2_CONFDIR}
	keepdir ${GTK2_CONFDIR}

	# Enable xft in environment as suggested by <utx@gentoo.org>
	dodir /etc/env.d
	echo "GDK_USE_XFT=1" > ${D}/etc/env.d/50gtk2

	dodoc AUTHORS ChangeLog* HACKING NEWS* README*

}

pkg_postinst() {

	set_gtk2_confdir

	if [ -d "${ROOT}${GTK2_CONFDIR}" ]; then
		gtk-query-immodules-2.0  > ${ROOT}${GTK2_CONFDIR}/gtk.immodules
		gdk-pixbuf-query-loaders > ${ROOT}${GTK2_CONFDIR}/gdk-pixbuf.loaders
	else
		ewarn "The destination path ${ROOT}${GTK2_CONFDIR} doesn't exist;"
		ewarn "to complete the installation of GTK+, please create the"
		ewarn "directory and then manually run:"
		ewarn "  cd ${ROOT}${GTK2_CONFDIR}"
		ewarn "  gtk-query-immodules-2.0  > gtk.immodules"
		ewarn "  gdk-pixbuf-query-loaders > gdk-pixbuf.loaders"
	fi

	einfo "If you experience text corruption issues, turn off RenderAccel"
	einfo "in your xorg.conf.  NVIDIA is working on this issue. "
	einfo "See http://bugs.gentoo.org/113123 for more information."

}
