# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/jacksum/jacksum-1.5.1.ebuild,v 1.6 2006/10/05 14:24:01 gustavoz Exp $

inherit java-pkg

DESCRIPTION="Java utility for computing and verifying checksums: CRC*, MD*, SHA*, TIGER"
HOMEPAGE="http://www.jonelo.de/java/jacksum/"
SRC_URI="mirror://sourceforge/jacksum/${P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE="jikes"
DEPEND=">=virtual/jdk-1.3.1
	dev-java/ant-core
	app-arch/unzip
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.3.1"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd ${S}
	unzip -qq ${PN}-src.zip || die "failed to unpack source"
	rm ${PN} *.jar
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compilation error"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc history.txt readme.txt help/*

	# make exec wrapper
	echo "#!/bin/sh" > ${PN}
	echo "cd /usr/share/${PN}" >> ${PN}
	echo '${JAVA_HOME}'/bin/java -jar lib/${PN}.jar '$*' >> ${PN}
	dobin ${PN}
}
