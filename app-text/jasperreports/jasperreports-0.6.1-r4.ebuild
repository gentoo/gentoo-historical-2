# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/jasperreports/jasperreports-0.6.1-r4.ebuild,v 1.5 2006/11/19 14:51:49 betelgeuse Exp $

inherit java-pkg

DESCRIPTION="JasperReports is a powerful report-generating tool that has the ability to deliver rich content onto the screen, to the printer or into PDF, HTML, XLS, CSV and XML files."
HOMEPAGE="http://jasperforge.org/sf/projects/jasperreports"
SRC_URI="mirror://sourceforge/jasperreports/${P}-project.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="jikes doc"
RDEPEND=">=virtual/jre-1.4
	dev-java/gnu-jaxp
	>=dev-java/itext-1.02
	>=dev-java/bsh-1.99
	=dev-java/commons-beanutils-1.6*
	>=dev-java/commons-collections-3.1
	>=dev-java/commons-digester-1.5
	>=dev-java/commons-logging-1.0.4
	>=dev-java/poi-2
	~dev-java/servletapi-2.3
	>=dev-java/xalan-2.5.2
	>=dev-java/xerces-2.6.2-r1"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	>=app-arch/unzip-5.50
	>=dev-java/ant-core-1.4
	jikes? ( >=dev-java/jikes-1.21 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf classes

	cd ${S}/lib
	rm -f *.jar

	java-pkg_jar-from itext iText.jar
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from bsh bsh.jar
	java-pkg_jar-from commons-beanutils-1.6
	java-pkg_jar-from commons-collections
	java-pkg_jar-from commons-digester
	java-pkg_jar-from commons-logging
	java-pkg_jar-from poi poi.jar
	java-pkg_jar-from servletapi-2.3
	java-pkg_jar-from xalan
	java-pkg_jar-from xerces-2 xercesImpl.jar
#	java-pkg_jar-from xerces-2 xmlParserAPIs.jar
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} docs"
	ant ${antflags} || die "Compilation failed"
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_newjar dist/${P}-applet.jar ${PN}-applet.jar
	use doc && java-pkg_dohtml -r docs/*
}
