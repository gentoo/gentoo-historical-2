# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jade-lib/jade-lib-7.0.6.ebuild,v 1.2 2004/10/16 17:18:08 axxo Exp $

inherit java-pkg

DESCRIPTION="Java Addition to Default Environment"
SRC_URI="http://jade.dautelle.com/jade-${PV}-src.zip"
HOMEPAGE="http://jade.dautelle.com/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/java-config-1.2
	dev-java/ant
	jikes? ( >=dev-java/jikes-1.17 )"
RDEPEND=">=virtual/jdk-1.4"
IUSE="doc jikes"

S="${WORKDIR}/jade-7.0"

src_compile() {
	local antflags="build"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compile problem"
}

src_install() {
	java-pkg_dojar jade.jar
	use doc && java-pkg_dohtml -r api
}
