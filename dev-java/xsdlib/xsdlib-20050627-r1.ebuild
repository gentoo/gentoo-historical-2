# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xsdlib/xsdlib-20050627-r1.ebuild,v 1.3 2006/11/30 16:01:59 caster Exp $

inherit java-pkg-2 java-ant-2

MY_P="${PN}.${PV}"
DESCRIPTION="The Sun Multi-Schema XML Validator is a Java tool to validate XML documents against several kinds of XML schemata."
HOMEPAGE="https://msv.dev.java.net/"
SRC_URI="mirror://gentoo/${MY_P}.zip"

LICENSE="as-is Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.3
	>=dev-java/xerces-2.7
	dev-java/relaxng-datatype"
DEPEND=">=virtual/jdk-1.3
	app-arch/unzip
	dev-java/ant-core
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/build-${PVR}.xml build.xml

	rm *.jar
	mkdir lib && cd lib
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom xerces-2
}

src_compile() {
	local antflags="-Dproject.name=${PN} jar"
	use doc && antflags="${antflags} javadoc"

	eant ${antflags} || die "Compilation failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc README.txt
	dohtml HowToUse.html

	use doc && java-pkg_dohtml -r dist/doc/api
	use source && java-pkg_dosrc src/* src-apache/*
}
