# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/slang/slang-1.4.5-r3.ebuild,v 1.4 2003/07/18 22:01:13 tester Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Console display library used by most text viewer"
SRC_URI="ftp://space.mit.edu/pub/davis/slang/v1.4/${P}.tar.gz"
LICENSE="GPL-2 | Artistic"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~mips ~hppa ~arm ~amd64"
SLOT="0"
HOMEPAGE="http://space.mit.edu/~davis/slang/"

DEPEND=">=sys-libs/ncurses-5.2-r2"
IUSE="cjk"

src_compile() {
	if [ -n "`use cjk`" ]
	then
		# enable Kanji Support
		cp src/sl-feat.h src/sl-feat.h.bak
		sed "/SLANG_HAS_KANJI_SUPPORT/s/0/1/" \
			src/sl-feat.h.bak > src/sl-feat.h
	fi

	# remove hardcoded compilers
	cp configure configure.orig
	sed -e "s:=\"gcc:=\"${CC:-gcc}:" \
		configure.orig > configure					 
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
