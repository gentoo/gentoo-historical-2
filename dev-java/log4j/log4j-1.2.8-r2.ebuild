# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/log4j/log4j-1.2.8-r2.ebuild,v 1.4 2004/10/16 17:29:18 axxo Exp $

inherit java-pkg

DESCRIPTION="A low-overhead robust logging package for Java"
SRC_URI="http://jakarta.apache.org/log4j/jakarta-${P}.tar.gz"
HOMEPAGE="http://jakarta.apache.org"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="jikes doc javamail jmx jms"
DEPEND=">=virtual/jdk-1.4
		dev-java/ant-core
		javamail? ( dev-java/sun-javamail-bin dev-java/sun-jaf-bin )
		jmx? ( dev-java/jmx )
		jms? ( =dev-java/openjms-bin-0.7.6 )
		jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/jakarta-${P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf dist/
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use javamail && antflags="${antflags} -Djavamail.jar=/usr/share/sun-javamail-bin/lib/mail.jar -Dactivation.jar=/usr/share/sun-jaf-bin/lib/activation.jar"
	use jmx && antflags="${antflags} -Djmx.jar=/usr/share/jmx/lib/jmxri.jar -Djmx-extra.jar=/usr/share/jmx/lib/jmxtools.jar"
	use jms && antflags="${antflags} -Djms.jar=/opt/openjms/lib/jms-1.0.2a.jar"
	ant ${antflags} || die "compilation error"
}

src_install() {
	cd dist/lib
	mv log4j-${PV}.jar ${PN}.jar
	java-pkg_dojar ${PN}.jar

	cd ${S}
	use doc && java-pkg_dohtml -r docs/*
}

