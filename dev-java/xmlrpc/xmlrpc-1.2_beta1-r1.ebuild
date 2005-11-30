# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmlrpc/xmlrpc-1.2_beta1-r1.ebuild,v 1.1 2005/07/13 10:40:36 axxo Exp $

inherit java-pkg

MY_PV=${PV/_beta/-b}

DESCRIPTION="Apache XML-RPC is a Java implementation of XML-RPC"
HOMEPAGE="http://ws.apache.org/xmlrpc/"
SRC_URI="http://www.apache.org/dist/ws/xmlrpc/v${MY_PV}/${PN}-${MY_PV}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE="jikes doc"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN}-${MY_PV}

src_compile() {
	local antflags="-Dbuild.dir=build -Dbuild.dest=dest -Dsrc.dir=src \
		-Djavadoc.destdir=api -Dfinal.name=xmlrpc-${MY_PV}"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die
}

src_install() {
	java-pkg_newjar build/xmlrpc-${MY_PV}.jar ${PN}.jar
	java-pkg_newjar build/xmlrpc-${MY_PV}-applet.jar ${PN}-applet.jar
	dodoc *.txt
	use doc && java-pkg_dohtml -r api
}

pkg_postinst() {
	einfo "This port does not build Servlet and/or SSL extensions. This port"
	einfo "does not provide examples examples either. Refer to README.txt for"
	einfo "more details on this."
}
