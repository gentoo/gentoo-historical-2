# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdparanoia/cdparanoia-3.9.8.ebuild,v 1.8 2002/07/17 01:47:07 seemant Exp $

MY_P=${PN}-III-alpha9.8
S=${WORKDIR}/${MY_P}
DESCRIPTION="an advanced CDDA reader with error correction"
SRC_URI="http://www.xiph.org/paranoia/download/${MY_P}.src.tgz"
HOMEPAGE="http://www.xiph.org/paranoia/index.html"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 ppc"

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
