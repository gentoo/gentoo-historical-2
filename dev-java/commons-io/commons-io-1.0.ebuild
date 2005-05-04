# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-io/commons-io-1.0.ebuild,v 1.2 2005/05/04 16:59:57 luckyduck Exp $

inherit java-pkg eutils

DESCRIPTION="Commons-IO contains utility classes  , stream implementations, file filters  , and endian classes."
HOMEPAGE="http://jakarta.apache.org/commons/io"
SRC_URI="mirror://apache/jakarta/commons/io/source/${PN}-${PV}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="1"
KEYWORDS="x86 amd64 ~ppc"
IUSE="doc jikes junit source"

DEPEND="jikes? ( >=dev-java/jikes-1.21 )
	junit? ( >=dev-java/junit-3.8 dev-java/ant )
	!junit? ( dev-java/ant-core )
	source? ( app-arch/zip )
	>=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-${PV}-gentoo.diff
	mkdir -p target/lib
	cd target/lib
	java-pkg_jar-from junit
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use junit && antflags="${antflags} test"
	ant ${antflags} || die "compile problem"
}

src_install() {
	mv target/${PN}-${PV}.jar target/${PN}.jar
	java-pkg_dojar target/${PN}.jar

	dodoc RELEASE-NOTES.txt
	dohtml PROPOSAL.html STATUS.html usersguide.html
	use doc && java-pkg_dohtml -r dist/docs/*
	use source && java-pkg_dosrc src/java/*
}
