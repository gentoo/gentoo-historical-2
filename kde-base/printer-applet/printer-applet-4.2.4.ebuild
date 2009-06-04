# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/printer-applet/printer-applet-4.2.4.ebuild,v 1.1 2009/06/04 13:51:25 alexxy Exp $

EAPI="2"

KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="KDE printer system tray utility"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-misc/hal-cups-utils
	>=dev-python/PyQt4-4.4.4-r1[dbus]
	>=kde-base/pykde4-${PV}:${SLOT}[kdeprefix=]
"
RDEPEND="${DEPEND}"
