# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/expat/expat-1.95.3.ebuild,v 1.3 2002/10/04 05:14:43 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="XML parsing libraries"
SRC_URI="mirror://sourceforge/expat/${P}.tar.gz"
HOMEPAGE="http://expat.sourceforge.net"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc sparc64"

src_compile() {
	./configure --prefix=/usr || die

	# parallel make doesnt work
	make || die
}

src_install() {
	make prefix=${D}/usr install || die

	dodoc COPYING Changes MANIFEST README
	dohtml doc/*
}
