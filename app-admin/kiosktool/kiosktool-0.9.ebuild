# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/kiosktool/kiosktool-0.9.ebuild,v 1.1 2004/10/14 15:58:56 voxus Exp $

inherit kde
need-kde 3.2

DESCRIPTION="KDE Kiosk GUI Admin Tool"
HOMEPAGE="http://extragear.kde.org/apps/kiosktool.php"
SRC_URI="mirror://kde/stable/apps/KDE3.x/admin/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="arts"
