# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/flute/flute-1.3.ebuild,v 1.1 2005/04/23 17:15:17 compnerd Exp $

inherit java-pkg

DESCRIPTION="Flute is an implementation for SAC"
HOMEPAGE="http://www.w3.org/Style/CSS/SAC/"
SRC_URI="http://www.w3.org/2002/06/flutejava-${PV}.zip"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc jikes source"

DEPEND="virtual/jdk
		app-arch/unzip
		dev-java/sac
		jikes? ( dev-java/jikes )
		source? ( app-arch/zip )"

RDEPEND="virtual/jre
		 dev-java/sac"

src_unpack() {
	unpack ${A}

	cp ${FILESDIR}/build.xml ${S}

	cd ${S}
	rm -f flute.jar

	mkdir src
	mv org src
}

src_compile() {
	echo "classpath=`java-config -p sac`" > ${S}/build.properties

	local antflags=""
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"

	ant ${antflags} || die "Compiling failed"
}

src_install() {
	dojar ${S}/dist/flute.jar

	use doc && java-pkg_dohtml -r ${S}/dist/doc/*
	dohtml ${S}/COPYRIGHT.html

	if use source; then
		java-pkg_dosrc ${S}/src/org || die "Failed to package sources"
	fi
}
