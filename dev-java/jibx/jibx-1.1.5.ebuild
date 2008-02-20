# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jibx/jibx-1.1.5.ebuild,v 1.1 2008/02/20 00:04:33 betelgeuse Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="JiBX: Binding XML to Java Code"
HOMEPAGE="http://jibx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEP="dev-java/dom4j:1
	dev-java/ant-core
	dev-java/bcel:0
	dev-java/jsr173:0
	dev-java/xpp3:0"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}

	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom ant-core
	java-pkg_jarfrom bcel
	java-pkg_jarfrom dom4j-1
	java-pkg_jarfrom jsr173
	java-pkg_jarfrom xpp3
}

EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="small-jars"

src_install() {
	java-pkg_dojar "${S}"/lib/*.jar

	dodoc changes.txt docs/binding.dtd docs/binding.xsd || die
	dohtml readme.html || die

	use doc && {
		java-pkg_dohtml -r docs/*
		cp -R starter "${D}/usr/share/doc/${PF}"
		cp -R tutorial "${D}/usr/share/doc/${PF}"
	}

	use source && java-pkg_dosrc ${S}/build/src/* ${S}/build/extras/*
}
