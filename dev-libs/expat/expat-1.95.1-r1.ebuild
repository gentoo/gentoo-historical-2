# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/expat/expat-1.95.1-r1.ebuild,v 1.2 2001/11/10 12:05:20 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="XML parsing libraries"
SRC_URI="http://download.sourceforge.net/expat/${P}.tar.gz"
HOMEPAGE="http://expat.sourceforge.net"

DEPEND="virtual/glibc"

src_compile() {      
	./configure --prefix=/usr || die

	emake || die
}

src_install() {                               
	make DESTDIR=${D} install || die

	dodoc COPYING Changes MANIFEST README 
	docinto html
	dodoc doc/*
}
