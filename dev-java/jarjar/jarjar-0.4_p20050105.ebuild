# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jarjar/jarjar-0.4_p20050105.ebuild,v 1.4 2005/07/16 11:25:46 axxo Exp $

inherit eutils java-pkg

DESCRIPTION="Reduce Java dependency headaches by repackaging third-party jars (evil!)."
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="http://jarjar.sourceforge.net"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="x86 amd64"
IUSE="doc jikes"
RDEPEND=">=virtual/jre-1.3
	=dev-java/asm-2*
	=dev-java/gnu-regexp-1*"
DEPEND=">=virtual/jdk-1.3
	${RDEPEND}
	jikes? ( >=dev-java/jikes-1.21 )
	>=dev-java/ant-core-1.4"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/asm-2.0_alpha-buildfile.patch

	cd ${S}/lib
	rm -f *.jar
	java-pkg_jar-from asm-2
	java-pkg_jar-from gnu-regexp-1
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "failed to build"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	if use doc; then
		java-pkg_dohtml -r dist/javadoc/*
	fi
}
