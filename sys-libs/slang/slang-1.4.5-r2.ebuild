# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/slang/slang-1.4.5-r2.ebuild,v 1.12 2003/01/18 14:34:42 tuxus Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Console display library used by most text viewer"
SRC_URI="ftp://space.mit.edu/pub/davis/slang/v1.4/${P}.tar.gz"
LICENSE="GPL-2 or Artistic"
KEYWORDS="x86 ppc sparc alpha mips"
SLOT="0"
HOMEPAGE="http://space.mit.edu/~davis/slang/"

DEPEND=">=sys-libs/ncurses-5.2-r2"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr || die "./configure failed"
	# emake doesn't work well with slang, so just use normal make.
	make all elf || die "make failed"
}

src_install() {
	make install install-elf DESTDIR=${D} || die "make install failed"
	( cd ${D}/usr/lib ; chmod 755 libslang.so.* )
	# remove the documentation... we want to install it ourselves
	rm -rf ${D}/usr/doc
	dodoc COPYING* NEWS README *.txt
	dodoc doc/*.txt doc/internal/*.txt doc/text/*.txt
	dohtml doc/*.html
}
