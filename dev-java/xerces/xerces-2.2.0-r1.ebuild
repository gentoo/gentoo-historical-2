# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xerces/xerces-2.2.0-r1.ebuild,v 1.3 2003/02/13 10:23:56 vapier Exp $

S=${WORKDIR}/xerces-${PV//./_}
DESCRIPTION="The next generation of high performance, fully compliant XML parsers in the Apache Xerces family"
SRC_URI="http://xml.apache.org/dist/xerces-j/Xerces-J-src.${PV}.tar.gz
	http://xml.apache.org/dist/xerces-j/Xerces-J-tools.${PV}.tar.gz"
HOMEPAGE="http://xml.apache.org/xerces2-j/index.html"
DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jdk-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	unpack ${A}
	mv tools ${S}
}

src_compile() {
	sh build.sh jars javadocs || die
}

src_install () {
	dojar build/x*.jar
	dodoc TODO STATUS README LICENSE ISSUES
	dohtml Readme.html

	dodir /usr/share/doc/${P}
	cp -a samples ${D}/usr/share/doc/${P}
	dohtml -r build/docs/javadocs
}
