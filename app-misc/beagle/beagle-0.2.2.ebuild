# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/beagle/beagle-0.2.2.ebuild,v 1.1 2006/03/07 16:36:31 metalgod Exp $

inherit gnome.org eutils autotools mono

DESCRIPTION="search tool that ransacks your personal information space to find whatever you're looking for"
HOMEPAGE="http://www.beagle-project.org/"

LICENSE="MIT Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug evo gtk ole pdf python"

RDEPEND="
	>=dev-lang/mono-1.1.10
	app-shells/bash
	app-arch/zip
	sys-devel/gettext
	>=x11-libs/gtk+-2.6.0
	>=dev-libs/atk-1.2.4
	>=dev-libs/gmime-2.1.19
	>=dev-dotnet/gtk-sharp-2.8
	>=gnome-base/librsvg-2.0
	>=media-libs/libexif-0.6.0
	>=dev-libs/libxml2-2.6.19

	||		( 	>=dev-db/sqlite-3.3.1
				=dev-db/sqlite-2* )

	||	(	(	x11-libs/libX11
				x11-libs/libXScrnSaver
				x11-libs/libXt )
		virtual/x11 )

	gtk?	(	>=dev-dotnet/gconf-sharp-2.8
				>=dev-dotnet/glade-sharp-2.8
				>=dev-dotnet/gnome-sharp-2.8
				>=dev-dotnet/gnome-sharp-2.8 )

	python? (	>=dev-lang/python-2.3
				>=dev-python/pygtk-2.6 )

	evo?	(	>=dev-dotnet/evolution-sharp-0.10.2
				>=dev-dotnet/gconf-sharp-2.3 )

	ole?	(	app-text/wv
				>=dev-dotnet/gsf-sharp-0.6
				>=app-office/gnumeric-1.4.3-r3 )
"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	|| ( (	x11-proto/xproto
		x11-proto/scrnsaverproto )
	virtual/x11 )"

pkg_setup() {
	if built_with_use dev-libs/gmime mono
	then
		einfo "Mono support enabled in dev-libs/gmime, I will continue..."
	else
		eerror "Please rebuild dev-libs/gmime, with mono support enabled!"
		eerror "Try USE=\"mono\" emerge dev-libs/gmime,"
		eerror "or add \"mono\" to your USE string in /etc/make.conf and"
		eerror "emerge dev-libs/gmime."
		die "Mono USE flag must be enabled in dev-libs/gmime"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# To prevent excessive revdep-rebuild, gentoo's libexif is sticking to
	# soversion 10 for now.
	sed -i -e 's/EXIF_SOVERSION=12/EXIF_SOVERSION=10/' configure.in

	# Multilib fix
	sed -i -e 's:prefix mono`/lib:libdir mono`:' \
		${S}/configure.in || die "sed failed"

	# Don't log so much
	! use debug && sed -i -e \
		's/defaultLevel = LogLevel.Debug/defaultLevel = LogLevel.Info/' \
		Util/Logger.cs

	epatch ${FILESDIR}/${PN}-0.2.1-multilib.patch

	eautoreconf
}

src_compile() {
	econf \
		$(use_enable evo evolution) \
		$(use_enable gtk gui) \
		$(use_enable python ) \
		--enable-libbeagle \
		|| die "configure failed"
	emake || die "Make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed!"

	dodir /usr/share/beagle
	insinto /usr/share/beagle
	doins mozilla-extension/beagle.xpi

	dodoc AUTHORS INSTALL NEWS README
}

pkg_postinst() {
	einfo "If available, Beagle greatly benefits from using certain operating"
	einfo "system features such as Extended Attributes and inotify."
	echo
	einfo "For more info on how to create the optimal beagle environment, and"
	einfo "basic usage info, see the Gentoo page of the Beagle website:"
	einfo " http://www.beagle-project.org/Gentoo_Installation"
}

