# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-digester/commons-digester-1.6-r1.ebuild,v 1.1 2005/05/14 16:10:48 luckyduck Exp $

inherit java-pkg

DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects within the system."
HOMEPAGE="http://jakarta.apache.org/commons/digester.html"
SRC_URI="mirror://apache/jakarta/commons/digester/source/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 ~ppc64"
IUSE="doc jikes junit"

DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-1.4
	junit? ( >=dev-java/junit-3.7 )
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jdk-1.3
	=dev-java/commons-beanutils-1.6*
	>=dev-java/commons-collections-2.1
	>=dev-java/commons-logging-1.0.2"
S=${WORKDIR}/${PN}-${PV}-src

src_compile() {
	local antflags="dist"
	use doc && antflags="${antflags} javadoc"
	use junit && antflags="${antflags} test"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"

	use junit && antflags="${antflags} -Djunit.jar=`java-config --classpath=junit`"
	antflags="${antflags} -Dcommons-beanutils.jar=`java-config --classpath=commons-beanutils-1.6 | sed s/:.*//`"
	antflags="${antflags} -Dcommons-collections.jar=`java-config --classpath=commons-collections`"
	antflags="${antflags} -Dcommons-logging.jar=/usr/share/commons-logging/lib/commons-logging.jar"
	ant ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && java-pkg_dohtml -r dist/docs/api/*
}
