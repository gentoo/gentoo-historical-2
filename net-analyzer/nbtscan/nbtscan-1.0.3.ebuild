# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nbtscan/nbtscan-1.0.3.ebuild,v 1.2 2002/07/11 06:30:43 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="NBTscan is a program for scanning IP networks for NetBIOS name information"
SRC_URI="http://www.inetcat.org/software/${P}.tar.gz"
HOMEPAGE="http://www.inetcat.org/software/nbtscan.html"

DEPEND="virtual/glibc"

src_compile() {

	./configure --host=${CHOST} --prefix=/usr  || die
	emake CFLAGS="${CFLAGS}" || die

}

src_install () {

	dobin nbtscan
	dodoc COPYING ChangeLog README

}
