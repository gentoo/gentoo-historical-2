# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-4.4.2.ebuild,v 1.2 2009/01/17 16:02:42 nixnut Exp $

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86"

IUSE="dbus opengl qt3support"

DEPEND=""
RDEPEND="~x11-libs/qt-gui-${PV}
	~x11-libs/qt-svg-${PV}
	~x11-libs/qt-test-${PV}
	~x11-libs/qt-sql-${PV}
	~x11-libs/qt-script-${PV}
	~x11-libs/qt-test-${PV}
	~x11-libs/qt-assistant-${PV}
	~x11-libs/qt-xmlpatterns-${PV}
	!sparc? ( !alpha? ( !ia64? ( ~x11-libs/qt-webkit-${PV} ) ) )
	dbus? ( ~x11-libs/qt-dbus-${PV} )
	opengl? ( ~x11-libs/qt-opengl-${PV} )
	qt3support? ( ~x11-libs/qt-qt3support-${PV} )"
