# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dbunit/dbunit-2.0.ebuild,v 1.4 2004/06/27 17:35:25 zx Exp $

inherit java-pkg

DESCRIPTION="DBUnit is a JUnit extension targeted for database-driven projects that, puts your database into a known state between test runs."
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
HOMEPAGE="http://www.dbunit.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jdk-1.3"
IUSE="doc"

src_compile() {	:; }

src_install() {
	mv ${S}/${P}.jar ${S}/${PN}.jar
	java-pkg_dojar ${PN}.jar
	use doc && dohtml -r docs/*
}
