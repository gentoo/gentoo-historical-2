# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/bzip2/bzip2-1.0.2.ebuild,v 1.3 2002/07/11 06:30:53 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
SRC_URI="ftp://sourceware.cygnus.com/pub/bzip2/v102/${P}.tar.gz
	ftp://ftp.freesoftware.com/pub/sourceware/bzip2/v102/${P}.tar.gz"
HOMEPAGE="http://sourceware.cygnus.com/bzip2/"
LICENSE="BZIP2"

DEPEND="virtual/glibc"


src_unpack() {
	
	unpack ${A}

	cd ${S}
	cp Makefile Makefile.orig
	sed -e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		Makefile.orig > Makefile
}

src_compile() {

	if [ -z "`use build`" ]
	then
		emake -f Makefile-libbz2_so all || die
	fi
	emake all || die
}

src_install() {

	if [ -z "`use build`" ]
	then
		make PREFIX=${D}/usr install || die
		mv ${D}/usr/bin ${D}
		dolib.so ${S}/libbz2.so.${PV}
		dosym /usr/lib/libbz2.so.${PV} /usr/lib/libbz2.so.1.0
		dosym /usr/lib/libbz2.so.${PV} /usr/lib/libbz2.so
		dodoc README LICENSE CHANGES Y2K_INFO
		docinto txt
		dodoc bzip2.txt
		docinto ps
		dodoc manual.ps
		docinto html
		dodoc manual_*.html
	else
		into /
		dobin bzip2
		cd ${D}/bin
		ln -s bzip2 bunzip2        
	fi
}


