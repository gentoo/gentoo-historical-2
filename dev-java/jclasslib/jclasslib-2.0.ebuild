# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jclasslib/jclasslib-2.0.ebuild,v 1.1.1.1 2005/11/30 09:47:27 chriswhite Exp $

inherit java-pkg eutils

MY_PV=${PV/./_}
DESCRIPTION="classlib bytecode viewer is a tool that visualizes all aspects of compiled Java class files and the contained bytecode. In addition, it contains a library that enables developers to read, modify and write Java class files and bytecode."
HOMEPAGE="http://www.ej-technologies.com/products/jclasslib/overview.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_unix_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE="doc jikes"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f bin/*.jar lib-compile/*.jar .install4j/*.jar
	epatch ${FILESDIR}/build.xml.patch
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	use doc && java-pkg_dohtml -r doc/*
}
