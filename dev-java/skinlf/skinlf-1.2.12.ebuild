# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/skinlf/skinlf-1.2.12.ebuild,v 1.1 2006/01/22 12:31:49 zzam Exp $

inherit java-pkg eutils

MY_P="${P}-20051009"

DESCRIPTION="Skin Look and Feel - Skinning Engine for the Swing toolkit"
HOMEPAGE="http://skinlf.l2fprod.com/"
SRC_URI="https://skinlf.dev.java.net/files/documents/66/22128/${MY_P}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="source"

RDEPEND=">=virtual/jre-1.3
	dev-java/javacc
	dev-java/xalan
	dev-java/xerces
	dev-java/sun-jimi"

DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-core-1.5.4
	dev-java/ant-tasks
	source? ( app-arch/zip )"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-image-utils.patch

	cp ${FILESDIR}/${P}-build.xml ${S}/build.xml
	cp ${FILESDIR}/${P}-common.xml ${S}/common.xml
	cp ${FILESDIR}/${P}-common-devjavanet.xml ${S}/common-devjavanet.xml

	cd ${S}/lib
	rm *.jar

	java-pkg_jar-from javacc
	java-pkg_jar-from xalan
	java-pkg_jar-from xerces-2
	java-pkg_jar-from sun-jimi sun-jimi.jar JimiProClasses.zip
}

src_compile() {
	local antflags="jar"
	#use doc && antflags="${antflags} public-doc"
	cd ${S}
	ant ${antflags} || die "compilation failed !"
}

src_install() {
	use source && java-pkg_dosrc src/*
	java-pkg_dojar build/skinlf.jar

	#java-pkg_dojar lib/skinlf.jar
	dodoc LICENSE LICENSE_nanoxml
}


