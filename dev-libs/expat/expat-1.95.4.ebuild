# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/expat/expat-1.95.4.ebuild,v 1.11 2003/01/06 22:18:56 tuxus Exp $

S=${WORKDIR}/${P}
DESCRIPTION="XML parsing libraries"
SRC_URI="mirror://sourceforge/expat/${P}.tar.gz"
HOMEPAGE="http://expat.sourceforge.net"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc alpha mips"

src_compile() {
    ./configure \
		--prefix=/usr \
		--mandir=/usr/share/man/man1 || die "configure failed"

	# parallel make doesnt work
	make || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 install || die "make install failed"

	dodoc COPYING Changes MANIFEST README
	dohtml doc/*
}
