# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netstat-nat/netstat-nat-1.3.1.ebuild,v 1.2 2003/02/13 15:02:12 vapier Exp $

DESCRIPTION="Display NAT connections"
HOMEPAGE="http://tweegy.demon.nl/projects/netstat-nat/index.html"
SRC_URI="http://tweegy.demon.nl/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="virtual/glibc"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv Makefile Makefile.orig
	sed <Makefile.orig >Makefile \
		-e "s|CC = gcc -O2|CC = gcc ${CFLAGS}|"
}

src_compile() {
	emake || die "compile problem"
}

src_install () {
	into /usr
	dosbin netstat-nat
	doman netstat-nat.1
	dodoc COPYING README
}
