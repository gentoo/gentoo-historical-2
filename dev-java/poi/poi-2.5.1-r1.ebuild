# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/poi/poi-2.5.1-r1.ebuild,v 1.2 2006/12/29 23:58:36 betelgeuse Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java API To Access Microsoft Format Files"
HOMEPAGE="http://jakarta.apache.org/poi/"
SRC_URI="mirror://apache/jakarta/poi/release/src/${PN}-src-${PV}-final-20040804.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4
	dev-java/xalan
	>=dev-java/commons-logging-1.0
	>=dev-java/log4j-1.2.8
	=dev-java/commons-beanutils-1.6*
	=dev-java/commons-lang-2.0*
	dev-java/junit"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	>=dev-java/ant-core-1.4"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f src/contrib/lib/*.jar lib/*.jar

	epatch ${FILESDIR}/${PN}-2.5-jikes-fix.patch
	sed -e 's:<target name="init" depends="check-jars,fetch-jars">:<target name="init" depends="check-jars">:' -i build.xml
	java-ant_rewrite-classpath build.xml
}

src_compile() {
	# prepackaged docs
	local deps="xalan,commons-logging,junit,commons-beanutils-1.6"
	deps="${deps},commons-lang,log4j"
	eant jar \
		-Dgentoo.classpath=$(java-pkg_getjars ${deps} )
}

src_install() {
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/contrib/src/org src/java/org/ src/scratchpad/src/org

	cd build/dist/
	java-pkg_newjar poi-scratchpad-${PV}* ${PN}-scratchpad.jar
	java-pkg_newjar poi-contrib-${PV}* ${PN}-contrib.jar
	java-pkg_newjar poi-${PV}* ${PN}.jar
}
