# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xerces-c/xerces-c-2.4.0-r1.ebuild,v 1.6 2004/07/02 04:57:24 eradicator Exp $

MY_PV=${PV//./_}

DESCRIPTION="Xerces-C++ is a validating XML parser written in a portable subset of C++."

SRC_URI="http://xml.apache.org/dist/xerces-c/stable/${PN}-src${MY_PV}.tar.gz"
HOMEPAGE="http://xml.apache.org/xerces-c/index.html"

DEPEND="virtual/libc
		doc? ( app-doc/doxygen )"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ~ppc amd64 ~sparc"
IUSE="doc"

S=${WORKDIR}/${PN}-src${MY_PV}

src_compile() {
	export MAKEOPTS="-j1"
	export XERCESCROOT=${S}
	cd src/xercesc
	econf || die
	emake || die
	unset MAKEOPTS
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
	dodoc STATUS LICENSE LICENSE.txt credits.txt version.incl xerces-c.spec
	dohtml Readme.html

	unset XERCESCROOT
}
