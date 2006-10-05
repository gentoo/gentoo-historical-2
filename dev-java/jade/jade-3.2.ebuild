# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jade/jade-3.2.ebuild,v 1.9 2006/10/05 17:18:18 gustavoz Exp $

inherit java-pkg

DESCRIPTION="JADE is FIPA-compliant Java Agent Development Environment"
SRC_URI="http://www.cs.bath.ac.uk/~occ/jade-dl/JADE-src-${PV}.zip"
HOMEPAGE="http://jade.cselt.it/"
IUSE="doc jikes"
DEPEND=">=virtual/jdk-1.3
	app-arch/unzip
	dev-java/ant-core
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.3"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"

S=${WORKDIR}/${PN}

src_compile() {
	local antflags="lib"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} doc"
	ant ${antflags} || die "compilation problem"
}

src_install() {
	java-pkg_dojar lib/*.jar
	dodoc README ChangeLog
	use doc && java-pkg_dohtml -r doc/*
}
