# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jzlib/jzlib-1.0.5.ebuild,v 1.10 2005/11/06 22:36:09 betelgeuse Exp $

inherit java-pkg

DESCRIPTION="JZlib is a re-implementation of zlib in pure Java."
HOMEPAGE="http://www.jcraft.com/jzlib/"
SRC_URI="http://www.jcraft.com/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 sparc amd64 ppc ppc64"
IUSE="doc jikes source"

DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.4
	source? ( app-arch/zip )
	jikes? ( >=dev-java/jikes-1.17 )"
RDEPEND=">=virtual/jre-1.4"


src_unpack() {
	unpack ${A}
	cp ${FILESDIR}/jzlib_build.xml ${S}/build.xml
	mkdir ${S}/src
	mv ${S}/com/ ${S}/src/
}

src_compile() {
	local antflags="dist"
	use doc && antflags="${antflags} javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_newjar dist/lib/jzlib*.jar jzlib.jar || die "installation failed"
	use doc && java-pkg_dohtml -r javadoc/*
	use source && java-pkg_dosrc src
	dodoc README ChangeLog
}
