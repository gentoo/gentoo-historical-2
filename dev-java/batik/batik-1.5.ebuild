# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/batik/batik-1.5.ebuild,v 1.1 2004/02/15 19:57:08 zx Exp $

inherit java-pkg

DESCRIPTION="Batik is a Java(tm) technology based toolkit for applications or applets that want to use images in the Scalable Vector Graphics (SVG) format for various purposes, such as viewing, generation or manipulation."
SRC_URI="http://xml.apache.org/batik/dist/${PN}-src-${PV}.zip"
HOMEPAGE="http://xml.apache.org/batik/"
IUSE="doc jikes"
DEPEND=">=virtual/jdk-1.3
		dev-java/ant
		jikes? ( dev-java/jikes )"

REDEPND=">=virtual/jdk-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ~sparc ~ppc"

S=${WORKDIR}/xml-batik

src_unpack() {
	jar xvf ${DISTDIR}/${PN}-src-${PV}.zip
}

src_compile() {
	local antflags="jars"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compile problem"
}

src_install () {
	java-pkg_dojar ${P}/batik*.jar ${P}/lib/*.jar

	dodoc README LICENSE
	use doc && dohtml -r ${P}/docs/
}
