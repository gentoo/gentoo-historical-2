# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/c3p0/c3p0-0.8.5_pre9.ebuild,v 1.1 2004/12/27 15:15:34 st_lim Exp $

inherit java-pkg

MY_PV=${PV/_pre/-pre}

DESCRIPTION="c3p0 is a java component to provide an jdbc database pool"
HOMEPAGE="http://c3p0.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.src.tgz"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-1.4"
RDEPEND=">=virtual/jre-1.3"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="jikes doc"

S=${WORKDIR}/${PN}-${MY_PV}.src

src_unpack() {
	unpack ${A}
	cd ${S}
	echo "j2ee.jar.base.dir=`java-config --jdk-home`" > build.properties
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadocs"
	ant ${antflags} || die "compilation failed"
}

src_install () {
	java-pkg_dojar build/${PN}*.jar || die "installation failed"
	dodoc README-SRC
	use doc && java-pkg_dohtml -r build/apidocs/*
}
