# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ktorrent/ktorrent-1.1.ebuild,v 1.1 2005/10/09 14:15:00 greg_g Exp $

inherit kde

DESCRIPTION="A BitTorrent program for KDE."
HOMEPAGE="http://ktorrent.pwsp.net/"
SRC_URI="http://ktorrent.pwsp.net/downloads/${PV}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

need-kde 3.3
