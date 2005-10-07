# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/adaptx/adaptx-0.9.13_p20041105.ebuild,v 1.13 2005/10/07 18:28:48 betelgeuse Exp $

inherit java-pkg

DESCRIPTION="Adaptx is an XSLT processor and XPath engine"
HOMEPAGE="http://project.exolab.org/cgi-bin/viewcvs.cgi/adaptx/?cvsroot=adaptx"
SRC_URI="http://dev.gentoo.org/~karltk/projects/java/distfiles/${PN}-20041105.gentoo.tar.bz2"
LICENSE="Exolab"
RDEPEND=">=virtual/jre-1.4
	=dev-java/rhino-1.5*
	=dev-java/log4j-1.2*
	dev-java/gnu-jaxp
	dev-java/xml-commons
	=dev-java/xerces-2.6*"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.4
	${RDEPEND}"
SLOT="0.9"
KEYWORDS="x86 amd64 ppc64 sparc ~ppc"
IUSE="doc"

S=${WORKDIR}/adaptx-20041105

src_unpack() {
	unpack ${A}
	cd ${S}/lib
	java-pkg_jar-from xerces-2 xercesImpl.jar
	java-pkg_jar-from xml-commons xml-apis.jar
	java-pkg_jar-from rhino-1.5
	java-pkg_jar-from gnu-jaxp
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from log4j
}

src_compile() {
	cd src/
	# tried to build sources with jikes but
	# failed all the time on different
	# plattforms (amd64, x86)
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "failed too build"
}

src_install() {
	java-pkg_dojar dist/*.jar
	use doc && java-pkg_dohtml -r build/doc/javadoc/*
	cd build/classes
	dodoc CHANGELOG README
}
