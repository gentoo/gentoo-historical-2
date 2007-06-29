# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-net/commons-net-1.4.1-r1.ebuild,v 1.11 2007/06/29 09:23:52 betelgeuse Exp $

# disabling unit tests:
# http://issues.apache.org/bugzilla/show_bug.cgi?id=37985
JAVA_PKG_IUSE="doc examples source" # junit

inherit eutils java-pkg-2 java-ant-2

MY_P="${P}-src"
DESCRIPTION="The purpose of the library is to provide fundamental protocol access, not higher-level abstractions."
HOMEPAGE="http://jakarta.apache.org/commons/net/"
SRC_URI="mirror://apache/jakarta/commons/net/source/${MY_P}.tar.gz"

# dev-java/oro had a package move to jakarta-oro so depend on a version
# that oro did not have. Most likely the cause of https://bugs.gentoo.org/show_bug.cgi?id=183595
COMMON_DEP="
	>=dev-java/jakarta-oro-2.0.8-r2"
RDEPEND=">=virtual/jre-1.3
	${COMMON_DEP}
	"
DEPEND=">=virtual/jdk-1.3
	${COMMON_DEP}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mkdir -p target/lib
	cd target/lib
	java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar oro.jar

	cd "${S}"
	# always disable tests
	sed -i 's/depends="compile,test"/depends="compile"/' build.xml || die "Failed to disable junit"
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc dist/docs/api
	use examples && java-pkg_doexamples src/java/examples
	use source && java-pkg_dosrc src/java/org
}
