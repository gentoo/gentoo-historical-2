# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/t1utils/t1utils-1.25.ebuild,v 1.6 2002/09/20 20:34:59 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Type 1 Font utilities"
SRC_URI="http://www.lcdf.org/type/${P}.tar.gz"
HOMEPAGE="http://www.lcdf.org/type/#t1utils"
KEYWORDS="x86 sparc sparc64"
SLOT="0"
LICENSE="BSD"

DEPEND="virtual/glibc"

src_compile() {

	./configure --prefix=/usr --mandir=/usr/share/man --host=${CHOST} || die
	emake || die

}

src_install () {

	make DESTDIR=${D} install || die
	dodoc NEWS README

}
