# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-demo/qt-demo-4.4.2.ebuild,v 1.1 2008/09/19 00:11:24 yngwin Exp $

EAPI="1"
inherit qt4-build

DESCRIPTION="Demonstration module of the Qt toolkit."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE=""

DEPEND="
	~x11-libs/qt-assistant-${PV}:${SLOT}
	~x11-libs/qt-core-${PV}:${SLOT}
	~x11-libs/qt-dbus-${PV}:${SLOT}
	~x11-libs/qt-gui-${PV}:${SLOT}
	~x11-libs/qt-opengl-${PV}:${SLOT}
	~x11-libs/qt-phonon-${PV}:${SLOT}
	~x11-libs/qt-qt3support-${PV}:${SLOT}
	~x11-libs/qt-script-${PV}:${SLOT}
	~x11-libs/qt-sql-${PV}:${SLOT}
	~x11-libs/qt-svg-${PV}:${SLOT}
	~x11-libs/qt-test-${PV}:${SLOT}
	~x11-libs/qt-webkit-${PV}:${SLOT}
	~x11-libs/qt-xmlpatterns-${PV}:${SLOT}
	!<=x11-libs/qt-4.4.0_alpha:${SLOT}
	"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="demos
	examples"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
	doc/src/images"

src_compile() {
	# Doesn't find qt-gui and fails linking
	sed -e '/QT_BUILD_TREE/ s:=:+=:' \
		-i "${S}"/examples/tools/plugandpaint/plugandpaint.pro \
		|| die "Fixing plugandpaint example failed."

	qt4-build_src_compile
}

src_install() {
	insinto ${QTDOCDIR}/src
	doins -r "${S}"/doc/src/images || die "Installing images failed."

	qt4-build_src_install
}
