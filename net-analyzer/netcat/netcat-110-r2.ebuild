# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netcat/netcat-110-r2.ebuild,v 1.4 2003/02/13 13:46:38 vapier Exp $

MY_P=nc${PV}
S=${WORKDIR}/nc-${PV}
DESCRIPTION="A network piping program"
SRC_URI="http://www.l0pht.com/~weld/netcat/${MY_P}.tgz"
HOMEPAGE="http://www.l0pht.com/~weld/netcat"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="virtual/glibc"

src_unpack() {
	mkdir ${S}
	cd ${S}
	tar zxf ${DISTDIR}/${A}
}

src_compile() {

	cp Makefile Makefile.orig
	sed -e "s:^CFLAGS =.*$:CFLAGS = ${CFLAGS}:" \
		-e "s:^CC =.*$:CC = gcc \$(CFLAGS):" \
		Makefile.orig > Makefile

	cp netcat.c netcat.c.orig
	sed -e "s:#define HAVE_BIND:#undef HAVE_BIND:" \
		netcat.c.orig > netcat.c

	make linux || die

}

src_install () {
	dobin nc
	dodoc README
	docinto scripts
	dodoc scripts/*
}
