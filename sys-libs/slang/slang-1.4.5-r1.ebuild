# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/slang/slang-1.4.5-r1.ebuild,v 1.16 2004/06/24 23:09:42 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Console display library used by most text viewer"
SRC_URI="ftp://space.mit.edu/pub/davis/slang/v1.4/${P}.tar.gz"
LICENSE="GPL-2 | Artistic"
KEYWORDS="x86 ppc sparc "
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
	docinto html
	dodoc doc/*.html
}
