# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Peter Gavin <pbg1854@garnet.acns.fsu.edu>
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdparanoia/cdparanoia-3.9.8.ebuild,v 1.5 2002/04/13 04:30:44 azarah Exp $

A=${PN}-III-alpha9.8.src.tgz
S=${WORKDIR}/${PN}-III-alpha9.8
DESCRIPTION="an advanced CDDA reader with error correction"
SRC_URI="http://www.xiph.org/paranoia/download/${A}"
HOMEPAGE="http://www.xiph.org/paranoia/index.html"

DEPEND="virtual/glibc"

src_compile() {

    ./configure --prefix=/usr || die
	#the configure script doesn't recognize i686-pc-linux-gnu
	#--host=${CHOST}
    make OPT="$CFLAGS" || die
}

src_install () {
    cd ${S}
    dodir /usr/bin /usr/lib /usr/share/man/man1 /usr/include
    make prefix=${D}/usr MANDIR=${D}/usr/share/man install || die
    dodoc FAQ.txt GPL README
}
