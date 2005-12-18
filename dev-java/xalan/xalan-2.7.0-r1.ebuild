# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan/xalan-2.7.0-r1.ebuild,v 1.1 2005/12/18 13:38:01 betelgeuse Exp $

inherit java-pkg eutils versionator

MY_PN="${PN}-j"
MY_PV="$(replace_all_version_separators _)"
MY_P="${MY_PN}_${MY_PV}"
DESCRIPTION="XSLT processor"
HOMEPAGE="http://xml.apache.org/xalan-j/index.html"
SRC_URI="mirror://apache/xml/${MY_PN}/source/${MY_P}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc jikes source"
RDEPEND=">=virtual/jre-1.4
	dev-java/javacup
	dev-java/bcel
	>=dev-java/jakarta-regexp-1.3-r2
	=dev-java/bsf-2.3*
	>=dev-java/xerces-2.6.2-r1
	=dev-java/xml-commons-external-1.3*"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.5.2
	jikes? ( dev-java/jikes )
	source? ( app-arch/zip )
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}/lib
	rm -f *.jar
	java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
	java-pkg_jar-from xerces-2 xercesImpl.jar
	java-pkg_jar-from javacup javacup.jar java_cup.jar
	java-pkg_jar-from javacup javacup.jar runtime.jar
	java-pkg_jar-from bcel bcel.jar BCEL.jar
	java-pkg_jar-from jakarta-regexp-1.3 jakarta-regexp.jar regexp.jar
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadocs -Dbuild.apidocs=build/docs/api"

	ant ${antflags} || die "ant failed"
}

src_install() {
	java-pkg_dojar build/*.jar
	use doc && java-pkg_dohtml -r build/docs/*
	use source && java-pkg_dosrc src/*
}
