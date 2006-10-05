# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbm/jdbm-0.12.ebuild,v 1.7 2006/10/05 17:34:14 gustavoz Exp $

inherit eutils java-pkg

DESCRIPTION="Jdbm aims to be for Java what GDBM is for Perl, Python, C, ..."
HOMEPAGE="http://jdbm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc jikes source"

RDEPEND=">=virtual/jre-1.4
	dev-java/jta
	=dev-java/xerces-1.3*"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	dev-java/ant-core
	app-arch/unzip
	jikes? ( dev-java/jikes )"

src_unpack() {
	unpack ${A}

	cd ${S}/src
	epatch ${FILESDIR}/${P}-buildfile.patch

	cd ${S}/lib
	rm *.jar
	java-pkg_jar-from jta
	java-pkg_jar-from xerces-2
}

src_compile() {
	cd ${S}/src

	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "ant failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && java-pkg_dohtml -r build/doc/javadoc/*
	use source && java-pkg_dosrc src/main/*
}
