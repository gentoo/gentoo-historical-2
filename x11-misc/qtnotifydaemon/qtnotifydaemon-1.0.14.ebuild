# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/qtnotifydaemon/qtnotifydaemon-1.0.14.ebuild,v 1.2 2012/01/30 12:31:45 ssuominen Exp $

EAPI=4
inherit qt4-r2

DESCRIPTION="A flexible and configurable notification daemon"
HOMEPAGE="http://drull.org.ru/qtnotifydaemon/ http://sourceforge.net/projects/qtnotifydaemon/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/qt-dbus:4
	x11-libs/qt-gui:4
	x11-libs/qt-qt3support:4
	!x11-misc/notification-daemon
	!x11-misc/notify-osd"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
	dobin ${PN}

	insinto /usr/share/dbus-1/services
	doins org.freedesktop.Notifications.service

	doman debian/${PN}.1
}
