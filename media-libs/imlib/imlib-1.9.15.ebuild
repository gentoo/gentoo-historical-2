# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/imlib/imlib-1.9.15.ebuild,v 1.4 2006/07/05 05:27:40 vapier Exp $

inherit eutils gnome.org libtool

DESCRIPTION="Image loading and rendering library"
HOMEPAGE="http://www.enlightenment.org/Libraries/Imlib.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="gtk static"

RDEPEND="gtk? ( =x11-libs/gtk+-1.2* )
	>=media-libs/tiff-3.5.5
	>=media-libs/giflib-4.1.0
	>=media-libs/libpng-1.2.1
	>=media-libs/jpeg-6b"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix config script #3425
	sed -i \
		-e "49,51D" \
		-e "55,57D" \
		imlib-config.in

	#Security fix for bug #72681
	epatch "${FILESDIR}"/${PN}-1.9.14-sec2.patch
	# shutup aclocal
	epatch "${FILESDIR}"/${PN}-1.9.14-m4.patch
	# Add configure switch to enable/disable Gdk functions. See bug #40453.
	epatch "${FILESDIR}"/${P}-gdk_flag.patch

	autoconf || die "autoconf failed"
	automake || die "automake failed"

	elibtoolize
}

src_compile() {
	econf \
		--sysconfdir=/etc/imlib \
		$(use_enable static) \
		$(use_enable gtk gdk) \
		$(use_enable gtk gtktest) \
		|| die
	emake || die
}

src_install() {
	einstall \
		includedir="${D}"/usr/include \
		sysconfdir="${D}"/etc/imlib \
		|| die

	dodoc AUTHORS ChangeLog README NEWS
	dohtml -r doc
}

pkg_postinst() {
	if ! use gtk; then
		ewarn "You have installed Imlib without support for Gdk. This may"
		ewarn "cause problems with packages that depend on the libgdk_imlib"
		ewarn "library. To install the complete set of Imlib libraries, please"
		ewarn "emerge it again with the 'gtk' USE flag enabled."
	fi
}
