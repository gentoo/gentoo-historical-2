# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-lang/commons-lang-2.1-r1.ebuild,v 1.4 2007/02/14 07:33:48 opfer Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Jakarta components to manipulate core java classes"
HOMEPAGE="http://jakarta.apache.org/commons/lang/"
SRC_URI="mirror://apache/jakarta/commons/lang/source/${P}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-core-1.6"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE="doc source"

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar

	if use doc; then
		dodoc RELEASE-NOTES.txt
		java-pkg_dohtml DEVELOPERS-GUIDE.html PROPOSAL.html STATUS.html
		java-pkg_dohtml -r dist/docs/
	fi
	use source && java-pkg_dosrc src/java/*
}
