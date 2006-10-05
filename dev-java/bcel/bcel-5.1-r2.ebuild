# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bcel/bcel-5.1-r2.ebuild,v 1.2 2006/10/05 15:10:40 gustavoz Exp $

inherit java-pkg eutils

DESCRIPTION="The Byte Code Engineering Library: analyze, create, manipulate Java class files"
HOMEPAGE="http://jakarta.apache.org/bcel/"
SRC_URI="mirror://apache/jakarta/bcel/source/${P}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ppc amd64 ppc64"
IUSE="doc jikes source"
RDEPEND=">=virtual/jre-1.3
	=dev-java/jakarta-regexp-1.3*"
DEPEND=">=virtual/jdk-1.3
	app-arch/unzip
	dev-java/ant-core
	jikes? ( dev-java/jikes )
	source? ( app-arch/zip )
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	unzip -q "${P}-src.zip" || die "failed to unpack"

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo-buildxml-r2.diff
	epatch ${FILESDIR}/${P}-gentoo-src.diff

	echo "regexp.jar=$(java-pkg_getjars jakarta-regexp-1.3)" > build.properties
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} apidocs"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_dojar bin/bcel.jar

	if use doc; then
		dodoc LICENSE.txt
		java-pkg_dohtml -r docs/
	fi
	use source && java-pkg_dosrc src/java/*
}
