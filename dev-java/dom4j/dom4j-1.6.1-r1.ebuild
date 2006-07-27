# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dom4j/dom4j-1.6.1-r1.ebuild,v 1.1 2006/07/27 20:23:43 nelchael Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Easy to use, open source library for working with XML, XPath and XSLT on the Java platform using the Java Collections Framework and with full support for DOM, SAX and JAXP."
HOMEPAGE="http://dom4j.sourceforge.net/"
SRC_URI="mirror://sourceforge/dom4j/${P}.tar.gz"
LICENSE="Apache-1.1"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc source"
RDEPEND="|| ( =virtual/jre-1.4* =virtual/jre-1.3* )
	dev-java/jaxme
	dev-java/jsr173
	dev-java/msv
	dev-java/xpp2
	dev-java/xpp3
	dev-java/relaxng-datatype
	=dev-java/xerces-2*
	dev-java/xsdlib"
DEPEND="|| (  =virtual/jdk-1.4* =virtual/jdk-1.3* )
	dev-java/ant-core
	${RDEPEND}"

src_unpack() {
	unpack ${A}

	cd ${S}/lib
	#circular deps with jaxen
	rm -f $(echo *.jar | sed 's/jaxen[^ ]\+//')
	java-pkg_jar-from jaxme
	java-pkg_jar-from jsr173
	java-pkg_jar-from msv
	java-pkg_jar-from xpp2
	java-pkg_jar-from xpp3
	java-pkg_jar-from relaxng-datatype
	java-pkg_jar-from xsdlib

	cd ${S}/lib/endorsed
	rm -f *.jar
	java-pkg_jar-from xerces-2 || die

	rm -r ${S}/lib/test
	# we don't really to fix any of these if we're not doing testing
#	# TODO: replace jsr173_1.0_ri.jar
#	java-pkg_jar-from ${JUNITPERF} || die

	# We don't need the stuff in tools
	rm -r ${S}/lib/tools
#	cd ${S}/lib/tools
#	# apparently we don't really need clover's jar
#	rm clover*
#	java-pkg_jar-from ${ISORELAX} || die
#	# TODO: replace jaxme-0.3.jar
#	# TODO: replace jaxme-js-0.3.jar
#	# TODO: replace jaxme-xs-0.3.jar
#	java-pkg_jar-from ${TIDY} || die
#	java-pkg_jar-from ${XALAN} || die
#	java-pkg_jar-from ${XERCES_IMPL} || die
}

src_compile() {
	local antflags="clean package"
	use doc && antflags="${antflags} -Dbuild.javadocs=build/doc/api javadoc"

	eant ${antflags} || die "Compilation failed"
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	use doc && java-pkg_dohtml -r build/doc/api
	use source && java-pkg_dosrc src/java/*
}
