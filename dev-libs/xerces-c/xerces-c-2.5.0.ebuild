# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xerces-c/xerces-c-2.5.0.ebuild,v 1.1 2004/08/15 18:31:05 vapier Exp $

MY_PV=${PV//./_}
MY_P=${PN}-src_${MY_PV}
DESCRIPTION="Xerces-C++ is a validating XML parser written in a portable subset of C++."
HOMEPAGE="http://xml.apache.org/xerces-c/index.html"
SRC_URI="http://www.apache.org/dist/xml/xerces-c/${MY_P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="doc"

DEPEND="virtual/libc
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_compile() {
	export XERCESCROOT=${S}
	cd src/xercesc
	econf || die
	emake -j1 || die
}

src_install () {
	export XERCESCROOT=${S}
	cd ${S}/src/xercesc
	make DESTDIR=${D} install || die

	if use doc; then
		dodir /usr/share/doc/${P}
		cp -a ${S}/samples ${D}/usr/share/doc/${P}
		cd ${S}/doc; doxygen
		dohtml -r html
	fi

	cd ${S}
	dodoc STATUS credits.txt version.incl
	dohtml Readme.html

	unset XERCESCROOT
}
