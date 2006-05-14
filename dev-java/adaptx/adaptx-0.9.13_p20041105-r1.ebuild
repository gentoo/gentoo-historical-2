# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/adaptx/adaptx-0.9.13_p20041105-r1.ebuild,v 1.12 2006/05/14 20:27:38 betelgeuse Exp $

inherit java-pkg

MY_PN=${PV%%_p*}
MY_SNAPSHOT=${PV##*_p}
DESCRIPTION="Adaptx is an XSLT processor and XPath engine"
HOMEPAGE="http://project.exolab.org/cgi-bin/viewcvs.cgi/adaptx/?cvsroot=adaptx"
SRC_URI="http://dev.gentoo.org/~karltk/projects/java/distfiles/${PN}-${MY_SNAPSHOT}.gentoo.tar.bz2"
LICENSE="Exolab"
RDEPEND=">=virtual/jre-1.4
	=dev-java/rhino-1.5*
	=dev-java/log4j-1.2*
	dev-java/gnu-jaxp
	dev-java/xml-commons
	>=dev-java/xerces-2.6"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.4
	${RDEPEND}"
SLOT="0.9"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE="doc"

S=${WORKDIR}/adaptx-20041105

src_compile() {
	local classpath="$(java-pkg_getjars \
		xerces-2,xml-commons,rhino-1.5,gnu-jaxp,log4j)"

	cd src/
	# tried to build sources with jikes but
	# failed all the time on different
	# plattforms (amd64, x86)
	local antflags="jar -Dclasspath=${classpath}"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "failed too build"
}

src_install() {
	java-pkg_newjar dist/${PN}_${MY_PN}.jar ${PN}.jar
	use doc && java-pkg_dohtml -r build/doc/javadoc/*
	cd build/classes
	dodoc CHANGELOG README
}
