# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-fileupload/commons-fileupload-1.2.1.ebuild,v 1.6 2011/12/19 12:44:30 sera Exp $

JAVA_PKG_IUSE="doc source"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Java library for adding robust, high-performance, file upload capability to your servlets and web applications."
HOMEPAGE="http://commons.apache.org/fileupload/"
SRC_URI="mirror://apache/commons/fileupload/source/${P}-src.tar.gz"
COMMON_DEPEND=">=dev-java/commons-io-1.3
	=dev-java/portletapi-1*
	~java-virtuals/servlet-api-2.4"
DEPEND=">=virtual/jdk-1.4
	test? (
		dev-java/ant-junit
		=dev-java/junit-3.8*
	)
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
LICENSE="Apache-2.0"
JAVA_PKG_FILTER_COMPILER="jikes"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

S="${WORKDIR}/${P}-src"

EANT_EXTRA_ARGS="-Dnoget=true -Dcommons-io.jar=true"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Tweak build classpath and don't automatically run tests
	epatch "${FILESDIR}/${P}-gentoo.patch"
	local libdir="${S}/target/lib"
	mkdir -p ${libdir}/commons-io/jars -p  ${libdir}/javax.servlet/jars -p  ${libdir}/javax.portlet/jars
	java-pkg_jar-from --into ${libdir}/commons-io/jars commons-io-1 commons-io.jar commons-io-1.3.2.jar
	java-pkg_jar-from --into ${libdir}/javax.servlet/jars --virtual servlet-api-2.4 servlet-api.jar servlet-api-2.4.jar
	java-pkg_jar-from --into ${libdir}/javax.portlet/jars portletapi-1 portletapi.jar portlet-api-1.0.jar
}

src_test() {
	mkdir -p target/lib/junit/jars
	java-pkg_jar-from --into "${S}"/target/lib/junit/jars junit junit.jar junit-3.8.1.jar
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
