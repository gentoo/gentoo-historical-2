# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dietlibc/dietlibc-0.6.13.ebuild,v 1.3 2001/06/23 21:34:37 achim Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A minimal libc"
SRC_URI="http://www.fefe.de/dietlibc/${P}.tar.bz2"
HOMEPAGE="http://www.fefe.de/dietlibc"


src_unpack() {
  unpack ${A}
  mkdir ${S}/include/asm
  cp /usr/include/asm/posix_types.h ${S}/include/asm
}

src_compile() {

    try make

}

src_install () {

    cd ${S}
    dodir /usr/include/dietlibc
    cp -a include/* ${D}/usr/include/dietlibc
    dolib.a dietlibc.a
    exeinto /usr/lib/dietlibc
    doexe start.o
    dodoc AUTHOR BUGS CAVEAT CHANGES README THANKS TODO


}

