# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/qat/qat-2.7.1-r1.ebuild,v 1.5 2005/05/16 22:26:23 luckyduck Exp $

inherit java-pkg

DESCRIPTION="Quality Assurance Tester - A distributed test harnass."
SRC_URI="mirror://sourceforge/qat/qat-${PV}-src.zip"
HOMEPAGE="http://qat.sourceforge.net"

LICENSE="sun-csl"
SLOT="0"
KEYWORDS="x86 ~sparc ppc amd64"
IUSE="doc examples jikes"

DEPEND=">=virtual/jdk-1.3
	app-arch/unzip
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.3
	dev-java/jlfgr
	dev-java/junit"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd ${S}/external/jlfgr/
	java-pkg_jar-from jlfgr jlfgr.jar jlfgr-1_0.jar
	cd ${S}/external/junit3.8.1/
	java-pkg_jar-from junit
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "failed to build"
}

src_install() {
	mv build/jar/${PN}-${PV}.jar build/jar/${PN}.jar
	java-pkg_dojar build/jar/${PN}.jar

	echo "#!/bin/sh" > ${PN}
	echo "java -classpath \$(java-config -p qat,junit,jlfgr) QAT" >> ${PN}

	dobin ${PN}

	use doc && java-pkg_dohtml -r doc/* && java-pkg_dohtml -r specification/*
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -R examples/* ${D}/usr/share/doc/${PF}/examples
	fi
}

