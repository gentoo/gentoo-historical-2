# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/cglib/cglib-2.0.2.ebuild,v 1.1 2004/12/27 14:54:56 st_lim Exp $

inherit java-pkg

DESCRIPTION="cglib is a Dynamic Java byte code generator"
HOMEPAGE="http://cglib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.jar"
DEPEND=">=virtual/jdk-1.3
	dev-java/asm
	>=dev-java/ant-1.4"
RDEPEND=">=virtual/jre-1.3"
LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="jikes doc"

S=${WORKDIR}

src_unpack() {
	cd ${S}
	jar xf ${DISTDIR}/${A}
	cd ${S}
	echo "j2ee.jar.base.dir=`java-config --jdk-home`" > build.properties
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	#use junit && antflags="${antflags} test"
	ant ${antflags} || die "compilation failed"
}

src_install () {
	java-pkg_dojar dist/${PN}-full-${PV}.jar || die "installation failed"
	dodoc README NOTICE LICENSE
	use doc && java-pkg_dohtml -r build/apidocs/*
}
