# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jaxen/jaxen-1.0-r1.ebuild,v 1.2 2006/07/29 22:59:07 nichoj Exp $

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A Java XPath Engine"
HOMEPAGE="http://jaxen.org/"
SRC_URI="mirror://sourceforge/jaxen/${P}-FCS.tar.gz"
LICENSE="jaxen"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc junit source"
COMMON_DEP="
	dev-java/xalan
	>=dev-java/xerces-2.6.2-r1
	=dev-java/dom4j-1*
	~dev-java/jdom-1.0_beta9
	dev-java/saxpath"

RDEPEND="|| ( >=virtual/jre-1.3* )
	${COMMON_DEP}"
# FIXME doesn't like Java 1.5's XML API
DEPEND="|| ( =virtual/jdk-1.3* =virtual/jdk-1.4* )
	dev-java/ant
	junit? ( dev-java/junit )
	${COMMON_DEP}"

S="${WORKDIR}/${P}-FCS"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/build.xml.patch
	mkdir src/conf
	cp ${FILESDIR}/MANIFEST.MF src/conf
	rm -f *.jar
	cd ${S}/lib
	rm -f *.jar

	java-pkg_jar-from saxpath
	java-pkg_jar-from xalan
	java-pkg_jar-from xerces-2
	java-pkg_jar-from dom4j-1
	use junit && java-pkg_jar-from junit
	java-pkg_jar-from jdom-1.0_beta9
}

src_compile() {
	local antops="package"
	use doc && antops="${antops} doc javadoc"
	use junit && antops="${antops} test.core"
	eant ${antops} || die "compile failed"
}

src_install() {
	java-pkg_dojar build/jaxen-full.jar

	use doc && java-pkg_dohtml -r build/doc/*
	use source && java-pkg_dosrc src/java/main/*
}
