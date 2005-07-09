# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/junit/junit-3.8.1-r1.ebuild,v 1.7 2005/07/09 16:05:44 axxo Exp $

inherit java-pkg

NP=${P/-/}
S=${WORKDIR}/${NP}
DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="mirror://sourceforge/${PN}/${NP}.zip"
HOMEPAGE="http://www.junit.org/"
LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 ppc64"
IUSE="doc jikes source"
DEPEND=">=virtual/jdk-1.3
	jikes? ( >=dev-java/jikes-1.21 )
	source? ( app-arch/zip )
	>=dev-java/ant-core-1.4
	>=app-arch/unzip-5.50-r1"
RDEPEND=">=virtual/jre-1.3"

src_unpack() {
	unpack ${A}
	cd ${S}
	unzip src.jar
	rm -f junit.jar
}

src_compile() {
	local antflags="dist"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "failed to build"
}

src_install() {
	use source && java-pkg_dosrc junit
	cd ${NP}
	java-pkg_dojar junit.jar
	dodir /usr/share/ant-core/lib
	dosym /usr/share/junit/lib/junit.jar /usr/share/ant-core/lib/
	java-pkg_dohtml -r README.html cpl-v10.html
	use doc && java-pkg_dohtml -r doc javadoc
}
