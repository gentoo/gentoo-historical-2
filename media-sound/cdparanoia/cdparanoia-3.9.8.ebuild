# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdparanoia/cdparanoia-3.9.8.ebuild,v 1.16 2002/12/15 10:44:20 bjb Exp $

MY_P=${PN}-III-alpha9.8
S=${WORKDIR}/${MY_P}
DESCRIPTION="an advanced CDDA reader with error correction"
SRC_URI="http://www.xiph.org/paranoia/download/${MY_P}.src.tgz"
HOMEPAGE="http://www.xiph.org/paranoia/"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha"

src_compile() {

	./configure --prefix=/usr || die
	#the configure script doesn't recognize i686-pc-linux-gnu
	#--host=${CHOST}
	
	make OPT="${CFLAGS}" || die
}

src_install() {
	dodir /usr/{bin,lib,include} /usr/share/man/man1
	make prefix=${D}/usr \
		MANDIR=${D}/usr/share/man \
		install || die
		
	dodoc FAQ.txt GPL README
}

