# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/shorten/shorten-3.2.ebuild,v 1.1 2001/01/16 05:22:17 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Open source, popular and fast lossless audio compressor"
SRC_URI="http://shnutils.freeshell.org/misc/shorten-3.2.tar.gz"
DEPEND=">=sys-libs/glibc-2.1.3"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv Makefile Makefile.orig
	sed -e "s:-O:${CFLAGS}:g" -e 's:/usr/local:/usr:g' Makefile.orig > Makefile
}

src_compile() {                           
	try make
}

src_install() {                               
	try make DESTDIR=${D}/usr install
	dodoc LICENSE
}

