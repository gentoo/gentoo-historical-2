# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-meta/qt-meta-4.8.ebuild,v 1.1 2012/01/29 17:03:37 wired Exp $

EAPI=2

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
HOMEPAGE="http://qt.nokia.com/ http://qt-project.org/"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="4"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="dbus kde opengl openvg qt3support"

DEPEND=""
RDEPEND="
	>=x11-libs/qt-core-${PV}
	>=x11-libs/qt-gui-${PV}
	>=x11-libs/qt-svg-${PV}
	>=x11-libs/qt-sql-${PV}
	>=x11-libs/qt-script-${PV}
	>=x11-libs/qt-xmlpatterns-${PV}
	dbus? ( >=x11-libs/qt-dbus-${PV} )
	opengl? ( >=x11-libs/qt-opengl-${PV} )
	openvg? ( >=x11-libs/qt-openvg-${PV} )
	!kde? ( || ( >=x11-libs/qt-phonon-${PV} media-libs/phonon ) )
	kde? ( media-libs/phonon )
	qt3support? ( >=x11-libs/qt-qt3support-${PV} )
	>=x11-libs/qt-webkit-${PV}
	>=x11-libs/qt-test-${PV}
	>=x11-libs/qt-multimedia-${PV}
	>=x11-libs/qt-declarative-${PV}
	>=x11-libs/qt-assistant-${PV}
"

pkg_postinst() {
	echo
	elog "Please note that this meta package is only provided for convenience."
	elog "No packages should depend directly on this meta package, but on the"
	elog "specific split Qt packages needed."
	echo
}
