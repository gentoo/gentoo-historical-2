# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/cglib/cglib-2.1.3.ebuild,v 1.14 2008/02/20 00:31:28 betelgeuse Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PV=${PV/1./1_}
DESCRIPTION="cglib is a powerful, high performance and quality Code Generation Library."
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${MY_PV}.jar"
HOMEPAGE="http://cglib.sourceforge.net"
LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="amd64 ppc x86"
COMMON_DEP="dev-java/asm:1.5
	dev-java/aspectwerkz:2
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	dev-java/jarjar
	${COMMON_DEP}"
IUSE=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jar-from asm-1.5
	java-pkg_jar-from aspectwerkz-2
	java-pkg_jar-from ant-core ant.jar
}

EANT_FILTER_COMPILER="ecj-3.3"
EANT_ANT_TASKS="jarjar-1"

# Does not work against our current version of aspectwerkz
# https://bugs.gentoo.org/show_bug.cgi?id=183997
#src_test() {
#	java-pkg_jar-from --into lib junit
#	eant test
#}

src_install() {
	java-pkg_newjar dist/${PN}-${MY_PV}.jar
	java-pkg_newjar dist/${PN}-nodep-${MY_PV}.jar ${PN}-nodep.jar

	dodoc NOTICE README || die
	use doc && java-pkg_dojavadoc docs/
	use source && java-pkg_dosrc src/proxy/net
}
