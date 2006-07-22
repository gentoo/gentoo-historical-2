# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-grant/commons-grant-1.0_beta5-r1.ebuild,v 1.1 2006/07/22 22:46:32 nelchael Exp $

# Note: Upstream is dead... only place to find is on the ibiblio maven repo
# and on jpackage.org
inherit java-pkg-2 java-ant-2 eutils rpm
MY_PN="jakarta-${PN}"
SNAPSHOT_DATE="20040118"
MY_PV="${PV%%_*}.b5.cvs${SNAPSHOT_DATE}"
MY_PV="${MY_PV//_beta/.b}"
MY_P="${MY_PN}-${MY_PV}"
JPACKAGE_REVISION="4"

DESCRIPTION="A small collection of hacks to make using Ant in an embedded envinronment much easier."
# This link seems dead, but I don't have anywhere else to turn
HOMEPAGE="http://jakarta.apache.org/commons/sandbox/grant/"
SRC_URI="mirror://jpackage/1.6/generic/free/SRPMS/${MY_P}-${JPACKAGE_REVISION}jpp.src.rpm"
DEPEND=">=virtual/jdk-1.3
	source? ( app-arch/zip )
	dev-java/ant-core
	dev-java/junit"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc source"
S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack(){
	rpm_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	mkdir -p target/lib
	cd target/lib
	java-pkg_jar-from junit
}

src_compile(){
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	eant ${antflags} || die "compile failed"
}

src_install(){
	java-pkg_newjar target/${PN}-1.0-beta-4.jar ${PN}.jar
	use doc && java-pkg_dohtml -r dist/docs/api
	use source && java-pkg_dosrc src/java/*
}

src_test() {
	eant test || die "Test failed"
}
