# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-demo/qt-demo-4.7.0.ebuild,v 1.2 2010/09/23 21:33:21 wired Exp $

EAPI="3"
inherit qt4-build

DESCRIPTION="Demonstration module of the Qt toolkit"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

DEPEND="~x11-libs/qt-assistant-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-core-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-dbus-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-gui-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-multimedia-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-opengl-${PV}:${SLOT}[aqua=]
	!kde? ( || ( ~x11-libs/qt-phonon-${PV}:${SLOT}[aqua=]
		media-sound/phonon[aqua=] ) )
	kde? ( media-sound/phonon[aqua=] )
	~x11-libs/qt-script-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-sql-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-svg-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-test-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-webkit-${PV}:${SLOT}[aqua=]
	~x11-libs/qt-xmlpatterns-${PV}:${SLOT}[aqua=]"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.6-plugandpaint.patch" )

pkg_setup() {
	QT4_TARGET_DIRECTORIES="demos
		examples"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		doc/src/images
		src/
		include/
		tools/"

	qt4-build_pkg_setup
}

src_install() {
	insinto "${QTDOCDIR#${EPREFIX}}"/src
	doins -r "${S}"/doc/src/images || die "Installing images failed."

	qt4-build_src_install
}
