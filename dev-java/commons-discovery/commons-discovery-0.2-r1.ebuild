# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-discovery/commons-discovery-0.2-r1.ebuild,v 1.3 2004/06/27 17:24:24 zx Exp $

inherit java-pkg

DESCRIPTION="The Discovery component is about discovering, or finding, implementations for pluggable interfaces."
HOMEPAGE="http://jakarta.apache.org/commons/discovery.html"
SRC_URI="mirror://apache/jakarta/commons/discovery/source/${PN}-${PV}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/commons-logging-1.0
	dev-java/junit
	>=dev-java/ant-1.4"
RDEPEND=">=virtual/jdk-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ppc ~sparc"
IUSE="doc jikes junit"

S="${WORKDIR}/${P}-src/discovery"

src_compile() {
	[ -f LICENSE.txt ] && cp LICENSE.txt ../LICENSE
	echo "logger.jar=`java-config --classpath=commons-logging | sed s/\=.*:/\=/`" >> build.properties
	echo "junit.jar=`java-config -p junit`" >> build.properties
	local antflags="dist"
	use junit && antflags="${antflags} compile.tests"
	ant ${antflags}
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && dohtml -r dist/docs/
	dohtml PROPOSAL.html STATUS.html best-practices.html
	dodoc TODO
}
