# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kbandwidth/kbandwidth-1.0.4.ebuild,v 1.5 2007/10/09 15:13:59 angelos Exp $

inherit kde

DESCRIPTION="Network monitoring Kicker-applet for KDE 3.x"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=18939"
SRC_URI="http://people.freenet.de/stealth/kbandwidth/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND=|| ( kde-base/kicker kde-base/kdebase )
need-kde 3.4
