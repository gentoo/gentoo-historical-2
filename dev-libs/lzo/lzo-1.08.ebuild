# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/lzo/lzo-1.08.ebuild,v 1.1 2002/09/21 22:33:11 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="An extremely fast compression and decompression library"
HOMEPAGE="http://www.oberhumer.com/opensource/lzo/"
SRC_URI="http://www.oberhumer.com/opensource/lzo/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="virtual/glibc"

src_compile() {
	econf --enable-shared || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README THANKS doc/LZO*
	docinto examples
	dodoc examples/*.c examples/Makefile
}
