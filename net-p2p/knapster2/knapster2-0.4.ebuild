# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/knapster2/knapster2-0.4.ebuild,v 1.11 2004/06/25 00:33:57 agriffis Exp $ 

IUSE=""

IUSE=""

inherit kde-base

need-kde 3

LICENSE="GPL-2"
KEYWORDS="x86 ppc"
SLOT="0"

S="${WORKDIR}/${P}"
DESCRIPTION="Napster Client for Linux"
SRC_URI="mirror://sourceforge/knapster/${P}.tar.gz"
HOMEPAGE="http://knapster.sourceforge.net"

src_unpack() {
	cd ${WORKDIR}
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-gcc3.2.diff || die
}
