# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/knapster2/knapster2-0.5.ebuild,v 1.4 2004/08/09 02:57:14 squinky86 Exp $ 

inherit kde libtool

DESCRIPTION="Napster Client for Linux"
HOMEPAGE="http://knapster.sourceforge.net"
SRC_URI="mirror://sourceforge/knapster/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""

need-kde 3

src_compile() {
	export CPPFLAGS=${CFLAGS}
	econf || die
	emake || die
}
