# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ngrep/ngrep-1.40.ebuild,v 1.10 2003/02/10 23:28:00 latexer Exp $

S=${WORKDIR}/ngrep
DESCRIPTION="A grep for network layers"
SRC_URI="mirror://sourceforge/ngrep/${P}.tar.gz"
HOMEPAGE="http://ngrep.sourceforge.net"

DEPEND="virtual/glibc
	>=net-libs/libpcap-0.5.2"

RDEPEND="virtual/glibc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc ~alpha"

src_compile() {
	
	econf || die
	make || die
}

src_install() {

	into /usr
	dobin ngrep
	doman ngrep.8
	dodoc BUGS CHANGES COPYRIGHT CREDITS README TODO USAGE
}



