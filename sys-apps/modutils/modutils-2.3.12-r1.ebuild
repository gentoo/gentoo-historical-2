# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/modutils/modutils-2.3.12-r1.ebuild,v 1.1 2000/08/02 17:07:13 achim Exp $

P=modutils-2.3.12
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Standard kernel module utilities"
CATEGORY="sys-apps"
SRC_URI="ftp://ftp.ocs.com.au/pub/modutils/v2.3/${A}"

src_compile() {                           
	./configure --prefix=/ --host=${CHOST}
	make $MAKEOPTS "MAKE = make $MAKEOPTS"
}

src_install() {                               
	cd ${S}
	dodir /sbin 
	dodir /usr/man/man1
	dodir /usr/man/man8
	dodir /usr/man/man5
	dodir /usr/man/man2
	make prefix=${D} mandir=${D}/usr/man install
	prepman
	strip ${D}/sbin/*
	dodoc COPYING CREDITS ChangeLog NEWS README TODO
}


