# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/eclipse-ecj/eclipse-ecj-3.1-r13.ebuild,v 1.8 2006/10/15 18:39:03 dertobi123 Exp $

inherit eutils java-pkg-2 java-ant-2

MY_PN=${PN##*-}

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="mirror://gentoo/${P}-gentoo-r2.tar.bz2"
LICENSE="EPL-1.0"
KEYWORDS="amd64 ppc ppc64 x86"
SLOT="3.1"

IUSE="doc"

RDEPEND=">=virtual/jre-1.4"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.4
	dev-java/ant-core"

src_compile() {
	java-ant_rewrite-classpath "${S}/build.xml"
	eant -Dgentoo.classpath=$(java-pkg_getjars ant-core) jar $(use_doc)
}

src_install() {
	java-pkg_dojar build/${MY_PN}.jar || die "ecj.jar not installable"

	dodoc README
	use doc && java-pkg_dohtml -r build/doc/api

	exeinto /usr/bin
	doexe ${MY_PN}-${SLOT}

	insinto /usr/share/java-config-2/compiler
	newins ${FILESDIR}/compiler-settings-${SLOT} ecj-${SLOT}

}

