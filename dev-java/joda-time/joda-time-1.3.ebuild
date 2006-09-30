# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/joda-time/joda-time-1.3.ebuild,v 1.1 2006/09/30 00:21:34 caster Exp $

inherit java-pkg-2 java-ant-2

MY_P="${P}-src"

DESCRIPTION="A quality open-source replacement for the Java Date and Time classes."
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc source test"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	source? ( app-arch/zip )
	test? (
		dev-java/junit
		dev-java/ant
	)"
RDEPEND=">=virtual/jre-1.4"

# test cases won't compile with 1.5+, overriding stuff not implementing abstract
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm ${P}.jar
}

src_compile() {
	# chokes on static inner class making instance of non-static inner class
	java-pkg_filter-compiler jikes
	# little trick so it doesn't try to download junit
	eant -Djunit.ant=1 -Djunit.present=1 jar $(use_doc)
}

src_test() {
	eant -Djunit.jar="$(java-pkg_getjars junit)" test
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar

	dodoc LICENSE.txt NOTICE.txt RELEASE-NOTES.txt ToDo.txt
	use doc && java-pkg_dojavadoc build/docs
	use source && java-pkg_dosrc src/java
}
