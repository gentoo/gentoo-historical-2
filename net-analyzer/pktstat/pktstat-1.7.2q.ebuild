# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/pktstat/pktstat-1.7.2q.ebuild,v 1.1.1.1 2005/11/30 10:12:28 chriswhite Exp $

DESCRIPTION="A network monitoring tool, with bandwidth tracking"
#SRC_URI="http://www.itee.uq.edu.au/~leonard/personal/software/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="http://www.itee.uq.edu.au/~leonard/personal/software/#pktstat"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libpcap
	>=sys-libs/ncurses-5.3-r1"

src_compile() {
	#Package doesn't use autoconf
	emake || die
}

src_install() {
	dosbin pktstat
	doman pktstat.1
	dodoc README
}
