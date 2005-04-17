# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iptstate/iptstate-1.3.ebuild,v 1.6 2005/04/17 08:41:10 eldad Exp $


DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
SRC_URI="http://www.phildev.net/iptstate/${P}.tar.gz"
HOMEPAGE="http://www.phildev.net/iptstate/"

DEPEND="sys-libs/ncurses"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc ~amd64"
IUSE=""

src_compile() {
	make CXXFLAGS="${CXXFLAGS} -g -Wall" all
}

src_install() {
	make PREFIX=${D}/usr install
	dodoc README Changelog BUGS CONTRIB LICENSE WISHLIST
}
