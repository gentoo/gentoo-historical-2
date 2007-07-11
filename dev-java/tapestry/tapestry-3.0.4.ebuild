# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/tapestry/tapestry-3.0.4.ebuild,v 1.1 2007/07/11 12:05:50 ali_bush Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Tapestry is an open-source framework for creating dynamic, robust, highly scalable web applications in Java."
SRC_URI="mirror://apache/${PN}/Tapestry-${PV}-src.zip"

HOMEPAGE="http://tapestry.apache.org/"
LICENSE="Apache-2.0"
SLOT="3.0"
KEYWORDS="~x86 ~amd64"
RDEPEND=">=virtual/jre-1.4
		>=dev-java/servletapi-2.4
		dev-java/commons-logging
		dev-java/commons-lang
		dev-java/commons-codec
		dev-java/commons-digester
		dev-java/commons-fileupload
		>=dev-java/commons-beanutils-1.7
		dev-java/bsf
		=dev-java/jakarta-oro-2.0*
		=dev-java/javassist-2.6*
		>=dev-java/ognl-2.6.9"

DEPEND=">=virtual/jdk-1.4
		>=dev-java/servletapi-2.4
		dev-java/commons-logging
		dev-java/commons-lang
		dev-java/commons-codec
		dev-java/commons-digester
		dev-java/commons-fileupload
		>=dev-java/commons-beanutils-1.7
		dev-java/bsf
		=dev-java/jakarta-oro-2.0*
		=dev-java/javassist-2.6*
		>=dev-java/ognl-2.6.9"

IUSE=""

S="${WORKDIR}/Tapestry-${PV}"

src_unpack() {
	unpack ${A}

	cd "${S}/"
	mkdir config

	cp "${FILESDIR}/Version.properties" config/
	cp "${FILESDIR}/build.properties" config/
	cp "${FILESDIR}/common.properties" config/

	cd "${S}/framework"
	java-ant_rewrite-classpath
}

src_compile() {
	mkdir lib

	cd framework

	gentoo_classpath="$(java-pkg_getjars commons-logging,commons-fileupload,commons-lang-2.1,commons-codec,commons-beanutils-1.7,commons-digester)"
	gentoo_classpath="$gentoo_classpath:$(java-pkg_getjars servletapi-2.4,ognl-2.6,bsf-2.3,jakarta-oro-2.0,javassist-2)"

	eant -Dgentoo.classpath="$gentoo_classpath"

	use doc && javadoc -sourcepath src/ org.apache.tapestry -d ../javadoc
}

src_install() {
	java-pkg_newjar "lib/${P}.jar"

	use source && java-pkg_dosrc framework/src/org
	use doc && java-pkg_dojavadoc javadoc
}
