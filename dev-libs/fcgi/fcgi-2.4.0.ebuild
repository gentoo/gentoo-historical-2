# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/fcgi/fcgi-2.4.0.ebuild,v 1.9 2004/11/08 23:44:38 mkennedy Exp $

DESCRIPTION="FastCGI Developer's Kit"
HOMEPAGE="http://www.fastcgi.com/"
SRC_URI="http://www.fastcgi.com/dist/${P}.tar.gz"
LICENSE="FastCGI"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install LIBRARY_PATH=${D}/usr/lib || die
	dodoc LICENSE.TERMS README
	mv doc/*.[13] . && doman *.[13]
	dohtml doc/*
	insinto /usr/share/doc/${P}/examples
	doins examples/*.c
	insinto /usr/share/doc/${P}/images
	doins images/*
}
