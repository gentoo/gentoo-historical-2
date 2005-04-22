# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/tagunit/tagunit-1.0.1.ebuild,v 1.8 2005/04/22 08:49:16 blubb Exp $

inherit java-pkg

DESCRIPTION="TagUnit is a tag library for testing custom tags within JSP pages."
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}-src.zip"
HOMEPAGE="http://www.tagunit.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
DEPEND=">=virtual/jdk-1.3
		app-arch/unzip
		>=dev-java/ant-1.6
		jikes? ( >=dev-java/jikes-1.17 )
		>=dev-java/servletapi-2.4"
RDEPEND=">=virtual/jdk-1.3"
IUSE="jikes doc"
S="${WORKDIR}/${P}-src/tagunit-core"

src_compile() {
	echo ${PV} > ../version.txt
	mkdir ../lib

	local antflags="build"
	antflags="${antflags} -lib `java-config --classpath=servletapi-2.4`"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_dojar lib/${PN}.jar
	cd ${S}/..
	dodoc changes.txt readme.txt
	use doc && java-pkg_dohtml -r doc/api/*
}
