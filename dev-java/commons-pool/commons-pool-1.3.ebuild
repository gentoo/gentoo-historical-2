# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-pool/commons-pool-1.3.ebuild,v 1.5 2007/03/12 07:49:56 betelgeuse Exp $

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Jakarta-Commons component providing general purpose object pooling API"
HOMEPAGE="http://jakarta.apache.org/commons/pool/"
SRC_URI="mirror://apache/jakarta/commons/pool/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86 ~x86-fbsd"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	test? ( >=dev-java/junit-3.7 )"

S="${WORKDIR}/${P}-src"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar
}

EANT_BUILD_TARGET="build-jar"

src_test() {
	echo "junit.jar=$(java-pkg_getjars junit)" >> build.properties
	eant test
}

src_install() {
	java-pkg_newjar dist/${P}.jar
	dodoc README.txt NOTICE.txt RELEASE-NOTES.txt || die

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/org
}
