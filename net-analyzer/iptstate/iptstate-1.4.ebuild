# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iptstate/iptstate-1.4.ebuild,v 1.4 2005/11/29 03:19:48 vapier Exp $

DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
SRC_URI="http://www.phildev.net/iptstate/${P}.tar.bz2"
HOMEPAGE="http://www.phildev.net/iptstate/"

DEPEND="sys-libs/ncurses"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

src_compile() {
	make CXXFLAGS="${CXXFLAGS} -g -Wall" all || die
}

src_install() {
	make PREFIX=${D}/usr install || die
	dodoc README Changelog BUGS CONTRIB LICENSE WISHLIST
}
