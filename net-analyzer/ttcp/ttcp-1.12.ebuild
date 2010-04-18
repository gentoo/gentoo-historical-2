# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ttcp/ttcp-1.12.ebuild,v 1.17 2010/04/18 16:55:45 nixnut Exp $

inherit toolchain-funcs eutils

IUSE=""
DESCRIPTION="Tool to test TCP and UDP throughput"
HOMEPAGE="http://ftp.arl.mil/~mike/ttcp.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 mips ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND=""

src_unpack() {
	unpack ${A} ; cd ${S}
	use amd64 && epatch ${FILESDIR}/ttcp-1.12-amd64.patch
}

src_compile() {
	$(tc-getCC) ${CFLAGS} -o ttcp sgi-ttcp.c || die "compile failed"
}

src_install() {
	dobin ttcp
	newman sgi-ttcp.1 ttcp.1
}
