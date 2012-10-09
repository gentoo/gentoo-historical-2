# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ftester/ftester-1.0.ebuild,v 1.7 2012/10/09 10:54:58 pinkbyte Exp $

DESCRIPTION="Ftester - Firewall and Intrusion Detection System testing tool"
HOMEPAGE="http://dev.inversepath.com/trac/ftester"
SRC_URI="http://dev.inversepath.com/ftester/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/Net-RawIP
	dev-perl/NetPacket
	dev-perl/Net-Pcap
	dev-perl/Net-PcapUtils
	dev-perl/List-MoreUtils"

src_install() {
	dodoc CREDITS Changelog ftest.conf
	doman ftester.8
	dosbin ftestd ftest freport || die
}
