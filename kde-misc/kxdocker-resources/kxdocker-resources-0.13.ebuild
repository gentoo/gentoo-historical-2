# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kxdocker-resources/kxdocker-resources-0.13.ebuild,v 1.1 2005/10/01 01:15:15 dragonheart Exp $

inherit kde

DESCRIPTION="KXDocker resources are base themes to help run KXDocker (the KDE animated docker)"
HOMEPAGE="http://www.xiaprojects.com/www/prodotti/kxdocker/main.php"
SRC_URI="http://www.xiaprojects.com/www/downloads/files/kxdocker/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

need-kde 3.2
