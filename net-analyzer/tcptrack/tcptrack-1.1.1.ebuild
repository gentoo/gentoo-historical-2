# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcptrack/tcptrack-1.1.1.ebuild,v 1.1 2004/05/14 17:41:33 squinky86 Exp $

IUSE=""

DESCRIPTION="Passive per-connection tcp bandwidth monitor"
SRC_URI="http://www.rhythm.cx/~steve/devel/tcptrack/release/${PV}/source/${P}.tar.gz"
HOMEPAGE="http://www.rhythm.cx/~steve/devel/tcptrack/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

newdepend ">=net-libs/libpcap-0.7.2
	   sys-libs/ncurses"

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
