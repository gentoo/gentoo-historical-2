# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/saxon/saxon-8.4b-r2.ebuild,v 1.3 2007/01/20 18:13:15 nixnut Exp $

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="The SAXON package is a collection of tools for processing XML documents: XSLT processor, XSL library, parser."
MyPV=${PV%b}
SRC_URI="mirror://sourceforge/saxon/saxonb${MyPV/./-}.zip"
HOMEPAGE="http://saxon.sourceforge.net/"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="ppc ~x86"
IUSE="doc source"

COMMON_DEP="
	dev-java/xom
	~dev-java/jdom-1.0
	=dev-java/xml-commons-external-1.3*"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/ant-core
	source? ( app-arch/zip )
	${COMMON_DEP}"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	unpack ./source.zip
	mkdir src
	mv net src

	epatch ${FILESDIR}/${P}-jikes.patch

	cp ${FILESDIR}/build-${PV}.xml build.xml

	rm  *.jar
	mkdir lib && cd lib
	java-pkg_jar-from jdom-1.0
	java-pkg_jar-from xom
	# Is not needed with 1.5 but gets pulled in by deps any way
	# without this emerging with sun-jdk-1.4 fails with
	# JAVA_PKG_STRICT
	java-pkg_jar-from xml-commons-external-1.3
}

src_install() {
	java-pkg_dojar dist/*.jar

	use doc && java-pkg_dohtml -r dist/doc/api doc/*
	use source && java-pkg_dosrc src/*
}
