# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/jpeg/jpeg-6b-r1.ebuild,v 1.1 2000/08/08 13:24:41 achim Exp $

P=jpeg-6b
A=jpegsrc.v6b.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libjpeg"
CATEGORY=media-libs
SRC_URI="ftp://ftp.uu.net/graphics/jpeg/"${A}
HOMEPAGE="http://www.ijg.org/"
src_compile() {
    ./configure --prefix=/usr --enable-shared --enable-static
    make
}

src_install() {                 
	cd ${S}
	mkdir ${D}/usr
	mkdir ${D}/usr/include
	mkdir ${D}/usr/lib
	mkdir ${D}/usr/bin
	mkdir ${D}/usr/man
	mkdir ${D}/usr/man/man1
	make install prefix=${D}/usr
	prepman
	dodoc README change.log structure.doc
}

