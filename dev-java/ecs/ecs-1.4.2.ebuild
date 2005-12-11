# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ecs/ecs-1.4.2.ebuild,v 1.4 2005/12/11 18:06:54 nichoj Exp $

inherit java-pkg

DESCRIPTION="Java library to generate markup language text such as HTML and XML"
HOMEPAGE="http://jakarta.apache.org/ecs"
SRC_URI="mirror://apache/jakarta/ecs/source/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc jikes source"

RDEPEND=">=virtual/jre-1.3
	=dev-java/jakarta-regexp-1.3*
	>=dev-java/xerces-2.6"
DEPEND=">=virtual/jdk-1.3
	${RDEPEND}
	dev-java/ant-core
	jikes? ( dev-java/jikes )
	source? ( app-arch/zip )"

S=${WORKDIR}/${P}-src

src_unpack() {
	unpack ${A}

	cd ${S}/lib && rm -f *.jar
	java-pkg_jar-from xerces-2 xercesImpl.jar xerces.jar
	java-pkg_jar-from jakarta-regexp-1.3 jakarta-regexp.jar regexp.jar
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadocs"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant -f build/build-ecs.xml ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_newjar bin/${P}.jar ${PN}.jar

	dodoc AUTHORS ChangeLog README
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/java/*
}
