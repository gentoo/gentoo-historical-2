# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-betwixt/commons-betwixt-0.7-r2.ebuild,v 1.2 2008/04/07 15:48:18 mr_bones_ Exp $

EAPI=1
JAVA_PKG_IUSE="doc test source"

inherit base java-pkg-2 eutils java-ant-2

DESCRIPTION="Introspective Bean to XML mapper"
HOMEPAGE="http://commons.apache.org/betwixt/"
SRC_URI="http://archive.apache.org/dist/${PN/-///}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0.7"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEP="
	dev-java/commons-collections:0
	>=dev-java/commons-logging-1.0.2
	dev-java/commons-beanutils:1.7
	>=dev-java/commons-digester-1.6"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	test? (
		dev-java/ant-junit
		>=dev-java/xerces-2.7
	)"

S="${WORKDIR}/${P}-src/"

PATCHES=( "${FILESDIR}/${P}-notests.patch" )

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"
EANT_GENTOO_CLASSPATH="commons-beanutils-1.7,commons-collections,commons-digester,commons-logging"
EANT_BUILD_TARGET="init jar"

src_test() {
	java-pkg_jar-from --into target/lib xerces-2,junit
	ANT_TASKS="ant-junit" eant test -DJunit.present=true
}

src_install() {
	java-pkg_newjar target/${PN}*.jar ${PN}.jar

	dodoc RELEASE-NOTES.txt README.txt || die
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
