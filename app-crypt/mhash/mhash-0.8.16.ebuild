# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mhash/mhash-0.8.16.ebuild,v 1.1 2002/06/13 23:14:56 stroke Exp $

S=${WORKDIR}/${P}
DESCRIPTION="mhash is a library providing a uniform interface to a large number of hash algorithms."
SRC_URI="http://telia.dl.sourceforge.net/sourceforge/mhash/${P}.tar.gz"
HOMEPAGE="http://mhash.sourceforge.net/"

DEPEND="virtual/glibc"

src_compile() {

	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc || die
		
	emake || die
}

src_install () {
	
	dodir /usr/{bin,include,lib}
	
	make prefix=${D}/usr \
	     mandir=${D}/usr/share/man \
	     infodir=${D}/usr/share/info \
	     sysconfdir=${D}/etc \
	     install || die

	dodoc AUTHORS COPYING INSTALL NEWS README TODO
	dodoc doc/*.txt doc/skid*
	dohtml -r doc
}
