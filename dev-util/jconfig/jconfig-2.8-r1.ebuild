# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/jconfig/jconfig-2.8-r1.ebuild,v 1.3 2005/10/15 11:49:31 axxo Exp $

inherit java-pkg

DESCRIPTION="jConfig is an extremely helpful utility, providing a simple API for the management of properties."
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-v${PV}.tar.gz"
HOMEPAGE="http://www.jconfig.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="doc jikes"
RDEPEND=">=virtual/jre-1.3
		dev-java/sun-jmx"
DEPEND=">=virtual/jdk-1.3
		${RDEPEND}
		dev-java/ant-core
		jikes? ( dev-java/jikes )"

S="${WORKDIR}/${PN/c/C}"

src_unpack() {
	unpack ${A}
	cd ${S}/lib/
	rm -f *.jar
	java-pkg_jar-from sun-jmx
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "failed to build"
}

src_install() {
	java-pkg_dojar dist/jconfig.jar
	use doc && java-pkg_dohtml -r javadoc/*

	dodoc README
}
