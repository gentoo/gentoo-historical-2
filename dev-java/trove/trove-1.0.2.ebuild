# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/trove/trove-1.0.2.ebuild,v 1.5 2005/07/14 13:12:49 agriffis Exp $

inherit java-pkg

DESCRIPTION="GNU Trove: High performance collections for Java."
SRC_URI="mirror://sourceforge/trove4j/${P}.tar.gz"
HOMEPAGE="http://trove4j.sourceforge.net"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant
	jikes? ( dev-java/jikes )
	source? ( app-arch/zip )"
IUSE="doc jikes source"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f lib/*.jar
	rm -fr javadocs/*
}

src_compile() {
	mkdir build
	javac_cmd="javac"
	use jikes && javac_cmd="jikes -bootclasspath ${JAVA_HOME}/jre/lib/rt.jar"

	cd src
	javac -nowarn -d ${S}/build $(find -name "*.java") \
		|| die "Failed to compile ${i}"

	if use doc ; then
		mkdir ${S}/javadoc
		javadoc -quiet -d ${S}/javadoc $(find * -type d | tr '/' '.')
	fi

	cd ${S}

	jar cf lib/${PN}.jar -C build gnu
}

src_install() {
	java-pkg_dojar lib/${PN}.jar
	dodoc *.txt ChangeLog AUTHORS
	use doc && java-pkg_dohtml -r javadoc
	use source && java-pkg_dosrc src/*
}
