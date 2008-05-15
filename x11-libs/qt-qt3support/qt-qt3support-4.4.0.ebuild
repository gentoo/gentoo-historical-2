# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-qt3support/qt-qt3support-4.4.0.ebuild,v 1.1 2008/05/15 12:47:21 ingmar Exp $

EAPI="1"
inherit qt4-build

DESCRIPTION="The Qt3 support module for the Qt toolkit."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( QPL-1.0 GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="+accessibility"

DEPEND="~x11-libs/qt-gui-${PV}
	~x11-libs/qt-sql-${PV}"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
src/qt3support
src/tools/uic3
tools/designer/src/plugins/widgets
tools/qtconfig
tools/porting"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
src/tools/uic/
"

pkg_setup() {
	QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK}
		~x11-libs/qt-core-${PV} qt3support
		~x11-libs/qt-gui-${PV} qt3support
		~x11-libs/qt-sql-${PV} qt3support"
	use accessibility && QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK}
		~x11-libs/qt-gui-${PV} accessibility"

	qt4-build_pkg_setup
}

src_compile() {
	local myconf
	myconf="${myconf} -qt3support -no-gstreamer -no-phonon
		$(qt_use accessibility)"

	qt4-build_src_compile
}
