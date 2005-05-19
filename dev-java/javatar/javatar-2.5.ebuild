# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javatar/javatar-2.5.ebuild,v 1.2 2005/05/19 13:41:46 luckyduck Exp $

inherit java-pkg eutils

DESCRIPTION="Java library for creation and extraction of tar archives"
HOMEPAGE="http://www.trustice.com/java/tar/"
SRC_URI="ftp://ftp.gjt.org/pub/time/java/tar/${P}.tar.gz"

LICENSE="public-domain"
SLOT="2.5"
IUSE="jikes doc"
KEYWORDS="x86 amd64"

DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-1.4
	jikes? ( dev-java/jikes )
	dev-java/sun-jaf-bin"
RDEPEND=">=virtual/jdk-1.4
	dev-java/sun-jaf-bin"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/javatar-2.5-build.xml build.xml

	mkdir ${S}/lib
	cd ${S}/lib
	rm -f *.jar
	java-pkg_jar-from sun-jaf-bin
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} docs"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compile failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dohtml -r docs/* doc/*.html

	echo "#!/bin/sh" > ${PN}
	echo "cp=\`java-config -p sun-jaf-bin\`" >> ${PN}
	echo "cp=\${cp}:\`java-config -p javatar-2.5\`" >> ${PN}
	echo "\`java-config -J\` -cp \${cp} com.ice.tar.tar" >> ${PN}

	insinto /usr
	dobin ${PN}
}
