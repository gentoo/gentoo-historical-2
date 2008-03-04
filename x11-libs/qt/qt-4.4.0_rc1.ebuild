# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-4.4.0_rc1.ebuild,v 1.12 2008/03/04 06:11:37 jer Exp $

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( QPL-1.0 GPL-2 )"
SLOT="4"
KEYWORDS="~hppa ~x86"

IUSE="opengl qt3support"

RDEPEND="~x11-libs/qt-gui-${PV}
	opengl? ( ~x11-libs/qt-opengl-${PV} )
	qt3support? ( ~x11-libs/qt-qt3support-${PV} )
	~x11-libs/qt-svg-${PV}
	~x11-libs/qt-test-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-svg-${PV}
	~x11-libs/qt-xmlpatterns-${PV}
	~x11-libs/qt-test-${PV}
	~x11-libs/qt-assistant-${PV}"
