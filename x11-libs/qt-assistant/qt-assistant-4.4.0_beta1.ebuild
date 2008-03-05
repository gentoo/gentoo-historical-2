# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-assistant/qt-assistant-4.4.0_beta1.ebuild,v 1.1 2008/03/05 23:13:57 ingmar Exp $

inherit qt4-build

DESCRIPTION="The assistant help module for the Qt toolkit."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( QPL-1.0 GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="~x11-libs/qt-gui-${PV}
	~x11-libs/qt-sql-${PV}"
RDEPEND="${DEPEND}"

# Pixeltool isn't really assistant related, but it relies on
# the assistant libraries.
QT4_TARGET_DIRECTORIES="tools/assistant tools/pixeltool"

pkg_setup() {
	qt4-build_pkg_setup

	if ! built_with_use x11-libs/qt-sql sqlite; then
		die "You must first emerge x11-libs/qt-sql with the \"sqlite\" use flag in order to use qt-assistant"
	fi
}

src_compile() {
	local myconf

	myconf="${myconf} -no-xkb -no-tablet -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-qdbus -iconv -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-xmlpatterns -no-freetype -no-libtiff  -no-accessibility -no-fontconfig
		-no-glib -no-opengl -no-qt3support"

	qt4-build_src_compile
}

src_install() {
	qt4-build_src_install
	domenu "${FILESDIR}"/assistant.desktop
	use doc && dohtml -r doc/html/*
}
