# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netcat/netcat-110-r1.ebuild,v 1.1 2002/10/22 08:15:23 seemant Exp $

MY_P=nc${PV}
S=${WORKDIR}
DESCRIPTION="A network piping program"
SRC_URI="http://www.l0pht.com/~weld/netcat/${MY_P}.tgz"
HOMEPAGE="http://www.l0pht.com/~weld/netcat"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="sys-apps/supersed"

src_compile() {

	einfo "Makefile corrections"
	ssed -i \
		-e "s:^CFLAGS =.*$:CFLAGS = ${CFLAGS}:" \
		-e "s:^CC =.*$:CC = gcc \$(CFLAGS):" \
		-e "s:nc:netcat:g" \
		Makefile

	einfo "netcat.c corrections"
	ssed -i "s:#define HAVE_BIND:#undef HAVE_BIND:" \
		netcat.c

	make linux || die

}

src_install () {
	dobin netcat
	dodoc README
	docinto scripts
	dodoc scripts/*
}

pkg_postinst() {
	einfo "The binary is now installed as /usr/bin/netcat instead of"
	einfo "/usr/bin/nc, because the latter is provided by"
	einfo "app-editors/nedit for a completely different purpose."
}
