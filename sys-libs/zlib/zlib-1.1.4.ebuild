# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-libs/zlib/zlib-1.1.4.ebuild,v 1.8 2002/09/14 15:51:26 bjb Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Standard (de)compression library"
SRC_URI="http://www.gzip.org/zlib/${P}.tar.bz2"
HOMEPAGE="http://www.gzip.org/zlib"
LICENSE="ZLIB"
KEYWORDS="x86 ppc sparc sparc64 alpha"
SLOT="0"

DEPEND="virtual/glibc"

src_compile() {

	./configure --shared --prefix=/usr || die

	if [ ${ARCH} = "alpha" ] ; then
        emake CFLAGS="$CFLAGS -fPIC" || die
    else
		emake || die
	fi

	make test || die

	./configure --prefix=/usr || die
	emake || die
}

src_install() {

	into /usr
	dodir /usr/include
	insinto /usr/include
	doins zconf.h zlib.h

	dolib libz.so.${PV}
	( cd ${D}/usr/lib ; chmod 755 libz.so.* )
	dolib libz.a
	dosym libz.so.${PV} /usr/lib/libz.so
	dosym libz.so.${PV} /usr/lib/libz.so.1

	doman zlib.3
	dodoc FAQ README ChangeLog
	docinto txt
	dodoc algorithm.txt
}
