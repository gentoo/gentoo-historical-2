# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/jpeg/jpeg-6b-r1.ebuild,v 1.4 2000/11/01 04:44:17 achim Exp $

P=jpeg-6b
A=jpegsrc.v6b.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libjpeg"
SRC_URI="ftp://ftp.uu.net/graphics/jpeg/"${A}
HOMEPAGE="http://www.ijg.org/"
DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {
    try ./configure --prefix=/usr --enable-shared --enable-static
    try make
}

src_install() {                 
	cd ${S}
	mkdir ${D}/usr
	mkdir ${D}/usr/include
	mkdir ${D}/usr/lib
	mkdir ${D}/usr/bin
	mkdir ${D}/usr/man
	mkdir ${D}/usr/man/man1
	try make install prefix=${D}/usr
	prepman
	dodoc README change.log structure.doc
}

