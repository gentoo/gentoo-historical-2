# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/poi/poi-2.0.ebuild,v 1.7 2005/02/06 01:06:21 luckyduck Exp $

inherit java-pkg eutils

DESCRIPTION="Java API To Access Microsoft Format Files"
HOMEPAGE="http://jakarta.apache.org/poi/"
SRC_URI="mirror://apache/jakarta/poi/release/src/${PN}-src-${PV}-final-20040126.tar.gz"
IUSE="jikes junit"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
DEPEND=">=virtual/jdk-1.2
		>=dev-java/ant-1.4"
RDEPEND=">=virtual/jdk-1.2
		dev-java/junit
		dev-java/xerces
		dev-java/jdepend
		dev-java/xalan
		dev-java/commons-logging
		dev-java/log4j
		dev-java/commons-beanutils
		dev-java/commons-collections
		dev-java/commons-lang
		jikes? ( dev-java/jikes )
		"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd ${S}
	use jikes && epatch ${FILESDIR}/${P}-jikes-fix.patch
}


src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use junit && antflags="${antflags} test"
	ant ${antflags} || die "compile problem"
}

src_install() {
	java-pkg_dojar build/dist/*.jar
}
