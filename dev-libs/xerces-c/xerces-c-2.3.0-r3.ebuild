# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xerces-c/xerces-c-2.3.0-r3.ebuild,v 1.3 2003/08/01 22:55:55 zhen Exp $

MY_PV=${PV//./_}

DESCRIPTION="Xerces-C++ is a validating XML parser written in a portable subset of C++."

SRC_URI="http://xml.apache.org/dist/xerces-c/stable/${PN}-src_${MY_PV}.tar.gz"
HOMEPAGE="http://xml.apache.org/xerces-c/index.html"

DEPEND="virtual/glibc"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="doc"

S=${WORKDIR}/${PN}-src_${MY_PV}

src_compile() {
	export XERCESCROOT=${S}
	cd src/xercesc
	./configure || die
	
	make || die
}

src_install () {
	cd ${S}/src/xercesc
	make PREFIX="${D}/usr" install
	cd ${XERCESCROOT}/lib
	dosym libxerces-c.so.23.0 libxerces-c.so
	dosym libxerces-c.so.23.0 libxerces-c.so.23	
	dolib.so libxerces-c.so.23.0

	if [ "`use doc`" ]; then
		dodir /usr/share/doc/${P}
		cp -a ${S}/samples ${D}/usr/share/doc/${P}
		dohtml -r doc/html
	fi

	cd ${S}
	dodoc STATUS LICENSE LICENSE.txt credits.txt version.incl xerces-c.spec
	dohtml Readme.html
		
	unset XERCESCROOT
}
