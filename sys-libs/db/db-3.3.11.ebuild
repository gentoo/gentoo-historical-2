# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-3.3.11.ebuild,v 1.3 2002/07/07 13:00:35 aliz Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Berkeley DB"

SRC_URI="http://www.sleepycat.com/update/3.3.11/db-3.3.11.tar.gz"

HOMEPAGE="http://www.sleepycat.com"
SLOT="3"
LICENSE="DB"

DEPEND="virtual/glibc"

src_compile() {

	cd dist
	
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die
	emake || die
}

src_install () {
	cd dist

	make prefix=${D}/usr install || die
	
	dodir /usr/share/doc/${PF}/html
	mv ${D}/usr/docs/* ${D}/usr/share/doc/${PF}/html/
}
