# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xerces-c/xerces-c-2.7.0.ebuild,v 1.3 2005/11/29 03:13:05 vapier Exp $

inherit eutils multilib

MY_PV=${PV//./_}
MY_P=${PN}-src_${MY_PV}
DESCRIPTION="Xerces-C++ is a validating XML parser written in a portable subset of C++."
HOMEPAGE="http://xml.apache.org/xerces-c/index.html"
SRC_URI="mirror://apache/xml/xerces-c/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="doc"

DEPEND="virtual/libc
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/xerces-c-src

src_unpack() {
	unpack ${A}
	cd ${S}

	# Fix multilib install
	epatch ${FILESDIR}/${P}-multilib.patch
}

src_compile() {
	export XERCESCROOT=${S}
	cd src/xercesc
	./runConfigure -plinux -P/usr
	emake -j1 || die
}

src_install () {
	export XERCESCROOT=${S}
	cd ${S}/src/xercesc
	make DESTDIR=${D} MLIBDIR=$(get_libdir) install || die

	if use doc; then
		dodir /usr/share/doc/${P}
		cp -pPR ${S}/samples ${D}/usr/share/doc/${P}
		cd ${S}/doc; doxygen
		dohtml -r html
	fi

	cd ${S}
	dodoc STATUS credits.txt version.incl
	dohtml Readme.html

	unset XERCESCROOT
}
