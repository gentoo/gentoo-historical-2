# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author George Shapovalov <georges@cco.caltech.edu>
# $Header: /var/cvsroot/gentoo-x86/app-arch/lzop/lzop-1.00.ebuild,v 1.2 2002/05/22 18:28:17 george Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Utility for fast (even reat-time) compression/decompression"
SRC_URI="http://www.oberhumer.com/opensource/lzop/download/${P}.tar.gz"
HOMEPAGE="http://www.oberhumer.com/opensource/lzop/"
DEPEND="virtual/glibc
		dev-libs/lzo"
RDEPEND="virtual/glibc"

src_compile() {                           
	./configure --host=${CHOST}					\
		    --prefix=/usr --disable-shared	||die

	emake || die
}

src_install() {                               
	make prefix=${D}/usr install || die

	dodoc AUTHORS ChangeLog COPYING* NEWS README THANKS
	dodoc doc/lzop.{txt,ps}
	dohtml doc/*.html
			
}
