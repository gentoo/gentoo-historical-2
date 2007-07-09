# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcptrack/tcptrack-1.2.0.ebuild,v 1.2 2007/07/09 17:28:23 armin76 Exp $

inherit eutils

DESCRIPTION="Passive per-connection tcp bandwidth monitor"
HOMEPAGE="http://www.rhythm.cx/~steve/devel/tcptrack/"
SRC_URI="http://www.rhythm.cx/~steve/devel/tcptrack/release/${PV}/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="net-libs/libpcap
	sys-libs/ncurses"

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
