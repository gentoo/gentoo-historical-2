# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fastutil/fastutil-4.1.ebuild,v 1.9 2005/01/01 18:24:08 eradicator Exp $

inherit java-pkg

DESCRIPTION="Provides type-specific maps, sets and lists with a small memory footprint for much faster access and insertion."
SRC_URI="http://fastutil.dsi.unimi.it/${P}-src.tar.gz"
HOMEPAGE="http://fastutil.dsi.unimi.it"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc jikes"
KEYWORDS="x86 ~sparc ppc ~amd64"

DEPEND=">=virtual/jdk-1.4
		 >=dev-java/ant-1.5.4"

src_compile() {
	make sources

	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	mv ${P}.jar ${PN}.jar
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dohtml -r docs/*
	dodoc CHANGES README
}

