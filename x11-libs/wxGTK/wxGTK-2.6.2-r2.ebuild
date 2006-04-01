# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/wxGTK/wxGTK-2.6.2-r2.ebuild,v 1.1 2006/04/01 06:09:14 antarus Exp $

inherit wxlib gnuconfig

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit and
wxbase non-gui library"

SLOT="2.6"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"
IUSE="gnome joystick odbc opengl sdl X"
RDEPEND="${RDEPEND}
	opengl? ( virtual/opengl )
	>=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	media-libs/tiff
	odbc? ( dev-db/unixODBC )
	x86? ( sdl? ( media-libs/sdl-sound ) )
	amd64? ( sdl? ( media-libs/sdl-sound ) )
	ppc? ( sdl? ( media-libs/sdl-sound ) )"

DEPEND="${RDEPEND}
	${DEPEND}
	dev-util/pkgconfig"
S=${WORKDIR}/wxWidgets-${PV}

pkg_setup() {
	einfo "To install only wxbase (non-gui libs) use USE=-X"
}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/wxWidgets-2.6.2-gcc41.patch
	epatch ${FILESDIR}/intl.cpp.diff
}

src_compile() {
	gnuconfig_update
	myconf="${myconf}
		--with-png
		--with-jpeg
		--with-tiff
		$(use_enable opengl)
		$(use_with opengl)
		$(use_with gnome gnomeprint)
		$(use_with sdl)
		$(use_enable joystick)"

	use X && configure_build gtk2 unicode "${myconf} --with-gtk=2"
	use X || configure_build base unicode "--disable-gui"
}

src_install() {
	use X && install_build gtk2
	use X || install_build base

	wxlib_src_install
}

pkg_postinst() {
	einfo "dev-libs/wxbase has been removed from portage and can be"
	einfo "installed with wxGTK by specifying the USE flags"
	einfo "-X"
}
