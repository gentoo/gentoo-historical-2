# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nethogs/nethogs-0.6.0.ebuild,v 1.6 2006/02/15 23:26:42 jokey Exp $

inherit eutils toolchain-funcs

HOMEPAGE="http://nethogs.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
DESCRIPTION="A small 'net top' tool, grouping bandwidth by process"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""
DEPEND="net-libs/libpcap"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}; cd "${S}"
	epatch "${FILESDIR}/${P}-gcc34.diff"
	# fix hardcoded CFLAGS and CC
	sed -i -e "s:-O2:${CFLAGS}:g" Makefile || die
	sed -i -e "s:g++:$(tc-getCXX):g" Makefile || die
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile || die
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	# Not using make install or einstall because of the hardcoded paths in Makefile
	dosbin nethogs
	doman nethogs.8
	dodoc Changelog DESIGN README
}
