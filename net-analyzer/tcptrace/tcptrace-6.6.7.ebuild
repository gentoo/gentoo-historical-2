# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcptrace/tcptrace-6.6.7.ebuild,v 1.5 2007/03/20 20:03:37 armin76 Exp $

IUSE=""

DESCRIPTION="A Tool for analyzing network packet dumps"
HOMEPAGE="http://www.tcptrace.org/"
SRC_URI="http://www.tcptrace.org/download/${P}.tar.gz
	http://www.tcptrace.org/download/old/6.6/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"

DEPEND="net-libs/libpcap"

src_install() {
	dobin tcptrace xpl2gpl

	newman tcptrace.man tcptrace.1
	dodoc CHANGES COPYING COPYRIGHT FAQ INSTALL README* THANKS WWW
}

pkg_postinst() {
	einfo
	einfo "Note: tcptrace outputs its graphs in the xpl (xplot)"
	einfo "format. Since xplot is unavailable, you will have to"
	einfo "use the included xpl2gpl utility to convert it to"
	einfo "the gnuplot format."
	einfo
}
