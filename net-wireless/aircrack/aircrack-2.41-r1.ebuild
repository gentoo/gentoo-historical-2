# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/aircrack/aircrack-2.41-r1.ebuild,v 1.1 2005/12/08 22:45:27 vanquirius Exp $

inherit toolchain-funcs eutils

MY_P="${P/_b/-b}"

DESCRIPTION="WLAN tool for breaking 802.11 WEP keys"
HOMEPAGE="http://www.cr0.net:8040/code/network/aircrack/"
SRC_URI="http://100h.org/wlan/aircrack/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/libc
	virtual/libpcap"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-stack.diff
}

src_compile() {
	emake -e CC=$(tc-getCC) || die "emake failed"
}

src_test() {
	 ./aircrack test/wpa.cap -w test/password.lst || die 'first selftest failed'
	#cd test
	#$(tc-getCC) $(CFLAGS) kstats.c  -o kstats
	#$(tc-getCC) $(CFLAGS)  makeivs.c -o makeivs
	#./makeivs iv.dat 33333333333333333333333333
	# SIGQUIT does not play nicely with sanbox
	#../aircrack ./iv.dat 
	#|| die 'second selftest failed'
}

src_install() {
	emake prefix=/usr docdir="/usr/share/doc/${PF}" DESTDIR="${D}" install doc \
		|| die "emake install failed"
}

