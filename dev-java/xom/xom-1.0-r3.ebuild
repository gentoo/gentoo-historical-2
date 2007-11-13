# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xom/xom-1.0-r3.ebuild,v 1.2 2007/11/13 23:31:48 betelgeuse Exp $

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

XOMVER="xom-${PV/_beta/b}"
DESCRIPTION="A new XML object model."
HOMEPAGE="http://cafeconleche.org/XOM/index.html"
SRC_URI="http://cafeconleche.org/XOM/${XOMVER}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	>=dev-java/xerces-2.7
	dev-java/xalan
	dev-java/junit
	=dev-java/icu4j-3.0*
	examples? ( =dev-java/servletapi-2.4* )
	dev-java/tagsoup"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S=${WORKDIR}/XOM

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_ignore-system-classes
	rm -v *.jar || die
	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jar-from junit
	java-pkg_jar-from xalan
	java-pkg_jar-from xerces-2
	java-pkg_jar-from icu4j icu4j.jar normalizer.jar
	java-pkg_jar-from tagsoup
}

src_compile() {
	eant jar -Ddebug=off -Dtagsoup.jar=lib/tagsoup.jar \
		-Dservlet.jar="$(java-pkg_getjar servletapi-2.4 servlet-api.jar)" \
		$(use examples && echo samples) \
		|| die "Failed Compiling"
}

src_install() {
	java-pkg_newjar build/${XOMVER}.jar ${PN}.jar
	use examples && java-pkg_dojar build/xom-samples.jar
	dodoc Todo.txt || die

	use doc && java-pkg_dojavadoc apidocs/
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples --subdir nu/xom/samples src/nu/xom/samples
}
