# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgroups/jgroups-2.2.7.ebuild,v 1.5 2005/07/12 19:33:14 axxo Exp $

inherit java-pkg

DESCRIPTION="JGroups is a toolkit for reliable multicast communication."
SRC_URI="mirror://sourceforge/javagroups/JGroups-${PV}.src.zip"
HOMEPAGE="http://www.jgroups.org/javagroupsnew/docs/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
RDEPEND=">=virtual/jre-1.4
	dev-java/concurrent-util
	dev-java/jms"
DEPEND=">=virtual/jdk-1.4*
	${RDEPEND}
	>=dev-java/ant-core-1.5
	app-arch/unzip
	junit? (
		dev-java/commons-logging
		dev-java/junit
		dev-java/log4j
	)
	jikes? ( dev-java/jikes )"
IUSE="doc junit jikes"

S=${WORKDIR}/JGroups-${PV}.src

src_unpack() {
	unpack ${A}
	cd ${S}/lib
	rm *.jar
	java-pkg_jar-from concurrent-util
	java-pkg_jar-from jms
	if use junit ; then
		ewarn "WARNING: Running unit tests can take a long time."
		java-pkg_jar-from junit
		java-pkg_jar-from commons-logging
		java-pkg_jar-from log4j
	fi
}

src_compile() {
	local antflags="compile-1.4 jgroups-core.jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	use junit && antflags="${antflags} unittests"
	ant ${antflags} || die "build failed"
}

src_install() {
	java-pkg_dojar dist/jgroups-core.jar
	dodoc doc/* CREDITS INSTALL.html README
	if use doc ; then
		cd dist
		java-pkg_dohtml -r javadoc
	fi
}
