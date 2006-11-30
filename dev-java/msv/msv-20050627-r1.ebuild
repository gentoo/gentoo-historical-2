# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/msv/msv-20050627-r1.ebuild,v 1.3 2006/11/30 15:50:39 caster Exp $

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Multi-Schema XML Validator, a Java tool for validating XML documents"
HOMEPAGE="http://www.sun.com/software/xml/developers/multischema/ https://msv.dev.java.net/"
SRC_URI="mirror://gentoo/${PN}.${PV}.zip"

LICENSE="BSD Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4
	dev-java/iso-relax
	dev-java/relaxng-datatype
	dev-java/xml-commons-resolver
	>=dev-java/xerces-2.7
	dev-java/xsdlib"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	source? ( app-arch/zip )
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
	eant -Dproject.name=${PN} jar $(use_doc)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc README.txt Changelog.txt

	use doc && java-pkg_dohtml -r dist/doc/api
	use source && java-pkg_dosrc src/*
}
