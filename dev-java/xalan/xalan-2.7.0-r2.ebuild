# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan/xalan-2.7.0-r2.ebuild,v 1.3 2006/07/21 18:32:17 nichoj Exp $

inherit java-pkg-2 java-ant-2 eutils versionator

MY_PN="${PN}-j"
MY_PV="$(replace_all_version_separators _)"
MY_P="${MY_PN}_${MY_PV}"
DESCRIPTION="XSLT processor"
HOMEPAGE="http://xml.apache.org/xalan-j/index.html"
SRC_URI="mirror://apache/xml/${MY_PN}/source/${MY_P}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc source"
COMMON_DEP="
	dev-java/javacup
	dev-java/bcel
	>=dev-java/jakarta-regexp-1.3-r2
	=dev-java/bsf-2.3*
	>=dev-java/xerces-2.6.2-r1
	=dev-java/xml-commons-external-1.3*"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.5.2
	source? ( app-arch/zip )
	${COMMON_DEP}"

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
	eant jar $(use_doc javadocs -Dbuild.apidocs=build/docs/api)
}

src_install() {
	java-pkg_dojar build/*.jar
	java-pkg_dolauncher ${PN} --main org.apache.xalan.xslt.Process
	use doc && java-pkg_dohtml -r build/docs/*
	use source && java-pkg_dosrc src/*
}
