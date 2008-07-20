# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/castor/castor-0.9.9.1-r4.ebuild,v 1.2 2008/07/20 16:29:20 ken69267 Exp $

EAPI=1
JAVA_PKG_IUSE="doc examples source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Data binding framework for Java"
SRC_URI="http://dist.codehaus.org/${PN}/${PV}/${P}-src.tgz"
HOMEPAGE="http://www.castor.org"
LICENSE="Exolab"
KEYWORDS="amd64 ~x86"
SLOT="0.9"
IUSE=""

COMMON_DEP="
	>=dev-java/commons-logging-1.0.4
	dev-java/jakarta-oro:2.0
	dev-java/jakarta-regexp:1.3
	dev-java/ldapsdk:4.1
	java-virtuals/servlet-api:2.3
	dev-java/xerces:1.3
	dev-java/cglib:2"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
# Does not like Java 1.6's JDBC API
DEPEND="|| (
		=virtual/jdk-1.5*
		=virtual/jdk-1.4*
	)
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	# TODO this should be filed upstream
	epatch "${FILESDIR}/0.9.5.3-jikes.patch"

	cd "${S}/lib"
	rm -v *.jar || die
	#FIXME: uses these bundled classes
	#rm -v tests/*.jar || die
	java-pkg_jar-from --build-only ant-core ant.jar
	#Only used by examples and tests and we aren't building them
	#java-pkg_jar-from adaptx-0.9
	java-pkg_jar-from commons-logging
	java-pkg_jar-from cglib-2
	java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar oro.jar
	java-pkg_jar-from jakarta-regexp-1.3 jakarta-regexp.jar regexp.jar
	java-pkg_jar-from --virtual servlet-api-2.3
	java-pkg_jar-from xerces-1.3
	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
}

EANT_BUILD_XML="src/build.xml"

src_install() {
	java-pkg_newjar dist/${P}.jar
	java-pkg_newjar dist/${P}-xml.jar ${PN}-xml.jar

	use doc && java-pkg_dojavadoc build/doc/javadoc
	use examples && java-pkg_doexamples src/examples
	use source && java-pkg_dosrc src/main/org
}
