# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/modutils/modutils-2.3.21.ebuild,v 1.2 2000/11/30 23:14:34 achim Exp $

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="Standard kernel module utilities"
SRC_URI="http://www.kernel.org/pub/linux/utils/kernel/modutils/v2.3/${A}
	 ftp://ftp.ocs.com.au/pub/modutils/v2.3/${A}"
DEPEND=">=sys-libs/glibc-2.1.3"
RDEPEND="$DEPEND
	 >=sys-apps/bash-2.04"

src_compile() {                           
	try ./configure --prefix=/ --host=${CHOST} --disable-strip
	try make ${MAKEOPTS}
}

src_install() {                               
	cd ${S}
	dodir /sbin 
	dodir /usr/man/man1
	dodir /usr/man/man8
	dodir /usr/man/man5
	dodir /usr/man/man2
	try make prefix=${D} mandir=${D}/usr/man install
	dodoc COPYING CREDITS ChangeLog NEWS README TODO
}




