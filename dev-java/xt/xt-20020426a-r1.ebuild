# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xt/xt-20020426a-r1.ebuild,v 1.1 2005/06/04 16:02:36 luckyduck Exp $

inherit java-pkg

MY_P="${PN}-${PV}-src"

DESCRIPTION="Java Implementation of XSL-Transformations"
SRC_URI="http://www.blnz.com/xt/${MY_P}.tgz"
HOMEPAGE="http://www.blnz.com/xt/"
LICENSE="JamesClark"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE="doc jikes"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	>=dev-java/xp-0.5
	~dev-java/servletapi-2.3
	dev-java/xml-commons
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f xt.jar lib/*.jar
	cd lib
	java-pkg_jar-from xml-commons xml-apis.jar
	java-pkg_jar-from xp
	java-pkg_jar-from servletapi-2.3 servlet.jar servlets.jar
}

src_compile() {
	cd src
	emake || die "compile failed"
}

src_install() {
	java-pkg_dojar xt.jar
	if use doc; then
		java-pkg_dohtml -r docs/* index.html
		dodoc README
	fi
}
