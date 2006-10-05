# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-pool/commons-pool-1.2-r1.ebuild,v 1.3 2006/10/05 15:32:41 gustavoz Exp $

inherit java-pkg eutils

DESCRIPTION="Jakarta-Commons component providing general purpose object pooling API"
HOMEPAGE="http://jakarta.apache.org/commons/pool/"
SRC_URI="mirror://apache/jakarta/commons/pool/source/${P}-src.tar.gz"
RDEPEND=">=virtual/jre-1.3
	>=dev-java/commons-collections-2.0"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-core-1.4
	${RDEPEND}
	junit? ( >=dev-java/junit-3.7 )
	jikes? ( dev-java/jikes )"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="jikes junit doc"

src_unpack() {
	unpack ${A}
	cd ${S}

	echo "commons-collections.jar=$(java-pkg_getjars commons-collections)" > build.properties
	use junit && echo "junit.jar=$(java-pkg_getjars junit)" >> build.properties
}

src_compile() {
	local antflags="build-jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	# TODO move unit tests to src_test
	use junit && antflags="${antflags} test"
	use doc && antflags="${antflags} javadoc"

	ant ${antflags} || die "Compilation Failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	dodoc README.txt
	dohtml STATUS.html PROPOSAL.html

	use doc && java-pkg_dohtml -r dist/docs/*
}
