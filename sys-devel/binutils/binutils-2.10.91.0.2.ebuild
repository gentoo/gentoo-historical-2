# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.10.91.0.2.ebuild,v 1.1 2001/02/21 05:46:13 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Tools necessary to build programs"
SRC_URI="http://ftp.valinux.com/pub/support/hjl/binutils/${A}"
DEPEND="virtual/glibc"

src_compile() {                           
	try ./configure --prefix=/usr --host=${CHOST}
	try make ${MAKEOPTS}
}

src_install() {
	try make prefix=${D}/usr install
	rm -rf ${D}/usr/share
	dodoc COPYING* README
	docinto bfd
        dodoc bfd/ChangeLog* bfd/COPYING bfd/README bfd/PORTING bfd/TODO
	docinto binutils
 	dodoc binutils/ChangeLog binutils/NEWS binutils/README
	docinto gas
	dodoc gas/ChangeLog* gas/CONTRIBUTORS gas/COPYING \
	      gas/NEWS gas/README*
	docinto gprof
	dodoc gprof/ChangeLog* gprof/NOTES gprof/TEST gprof/TODO
	docinto ld
	dodoc ld/ChangeLog* ld/README ld/NEWS ld/TODO
	docinto libiberty
	dodoc libiberty/ChangeLog* libiberty/COPYING.LIB libiberty/README 
	docinto opcodes
	dodoc opcodes/ChangeLog* 
	
}



