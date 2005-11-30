# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/proxool/proxool-0.8.3.ebuild,v 1.1 2004/12/27 15:22:11 st_lim Exp $

inherit java-pkg

DESCRIPTION="Proxool is a Java connection pool."
HOMEPAGE="http://proxool.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"
DEPEND=">=virtual/jdk-1.3
	dev-java/cglib
	>=dev-java/ant-1.4"
RDEPEND=">=virtual/jre-1.3"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="jikes doc"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	local antflags="build-jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "compilation failed"
}

src_install () {
	java-pkg_dojar build/${P}.jar || die "installation failed"
	dodoc README.txt
	use doc && java-pkg_dohtml -r doc/*
}
