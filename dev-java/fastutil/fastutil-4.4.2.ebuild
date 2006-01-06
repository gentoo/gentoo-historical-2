# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fastutil/fastutil-4.4.2.ebuild,v 1.1 2006/01/06 04:49:29 nichoj Exp $

inherit java-pkg

DESCRIPTION="Provides type-specific maps, sets and lists with a small memory footprint for much faster access and insertion."
SRC_URI="http://fastutil.dsi.unimi.it/${P}-src.tar.gz"
HOMEPAGE="http://fastutil.dsi.unimi.it"
LICENSE="LGPL-2.1"
SLOT="4.4"
IUSE="doc jikes source"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"

DEPEND=">=virtual/jdk-1.4
	 >=dev-java/ant-core-1.6
	 jikes? ( dev-java/jikes )
	 source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"

src_compile() {
	make sources || die "failed to make sources"

	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_newjar ${P}.jar ${PN}.jar

	dodoc CHANGES README

	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc java/it
}

