# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/oooqs/oooqs-2.0.3.ebuild,v 1.1 2004/03/13 14:09:17 pyrania Exp $

inherit kde

need-kde 3

DESCRIPTION="OpenOffice.org Quickstarter, runs in the KDE SystemTray"
HOMEPAGE="http://segfaultskde.berlios.de/index.php"
SRC_URI="http://download.berlios.de/segfaultskde/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"

pkg_postinst()
{
	einfo "If upgrading from version 2.0, please remove the oooqs.desktop file from"
	einfo "your "Autostart" directory (linked in the "Goto" menu in Konqueror)."
}
