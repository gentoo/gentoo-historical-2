# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xerces/xerces-2.3.0.ebuild,v 1.7 2004/09/17 09:31:54 axxo Exp $

inherit java-pkg

S=${WORKDIR}/xerces-${PV//./_}
DESCRIPTION="The next generation of high performance, fully compliant XML parsers in the Apache Xerces family"
HOMEPAGE="http://xml.apache.org/xerces2-j/index.html"
SRC_URI="http://xml.apache.org/dist/xerces-j/Xerces-J-src.${PV}.tar.gz
	http://xml.apache.org/dist/xerces-j/Xerces-J-tools.${PV}.tar.gz"

LICENSE="Apache-1.1"
SLOT="2.3"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jdk-1.3"
IUSE="doc"

src_unpack() {
	unpack ${A}
	mv tools ${S}
}

src_compile() {
	sh build.sh jars || die "failed to compile"
	if use doc; then
		sh build.sh javadocs || die "failed to create javadoc"
	fi
}

src_install () {
	java-pkg_dojar build/x*.jar
	dodoc TODO STATUS README LICENSE ISSUES
	dohtml Readme.html

	if use doc; then
		dodir /usr/share/doc/${P}
		cp -a samples ${D}/usr/share/doc/${P}
		dohtml -r build/docs/javadocs
	fi
}
