# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/msv/msv-20050627.ebuild,v 1.5 2006/01/23 04:11:06 nichoj Exp $

inherit java-pkg eutils

DESCRIPTION="The Sun Multi-Schema XML Validator (MSV) is a Java technology tool to validate XML documents against several kinds of XML schemata."
HOMEPAGE="http://www.sun.com/software/xml/developers/multischema/ https://msv.dev.java.net/"
SRC_URI="mirror://gentoo/${PN}.${PV}.zip"

LICENSE="BSD Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc jikes source"

RDEPEND=">=virtual/jre-1.4
	dev-java/iso-relax
	dev-java/relaxng-datatype
	dev-java/xml-commons-resolver
	=dev-java/xerces-2*
	dev-java/xsdlib"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	source? ( app-arch/zip )
	jikes? ( dev-java/jikes )
	dev-java/ant-core
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm *.jar

	mkdir lib && cd lib
	local pkg
	for pkg in iso-relax relaxng-datatype xerces-2 xml-commons-resolver xsdlib; do
		java-pkg_jarfrom ${pkg}
	done
	cd ${S}

	cp ${FILESDIR}/build-${PV}.xml build.xml
}

src_compile() {
	local antflags="-Dproject.name=${PN} jar"
	use jikes && antflags="-Dbuild.compiler=jikes ${antflags}"
	use doc && antflags="${antflags} javadoc"


	ant ${antflags} || die "Compilation failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc README.txt Changelog.txt

	use doc && java-pkg_dohtml -r dist/doc/api
	use source && java-pkg_dosrc src/*
}
