# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-collections/commons-collections-3.1.ebuild,v 1.6 2005/01/20 17:05:26 luckyduck Exp $

inherit java-pkg eutils

DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="http://jakarta.apache.org/commons/collections.html"
SRC_URI="mirror://apache/jakarta/commons/collections/source/${PN}-${PV}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 sparc ppc amd64 ~ppc64"
IUSE="doc jikes"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-1.4
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.3"

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	#when this is installed as a dep on ant
	#junit ant task is not installed yet. so it cannot run
	#use junit && antflags="${antflags} test"
	ant ${antflags} || die "compile failed"
}

src_install() {
	mv build/${P}.jar build/${PN}.jar
	java-pkg_dojar build/${PN}.jar
	dodoc LICENSE.txt README.txt
	use doc && java-pkg_dohtml -r build/docs/apidocs
	dohtml *.html
}
