# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc-mysql/jdbc-mysql-3.1.7.ebuild,v 1.2 2005/06/17 18:24:24 axxo Exp $

inherit eutils java-pkg

At=mysql-connector-java-${PV}

DESCRIPTION="MySQL JDBC driver"
HOMEPAGE="http://www.mysql.com"
SRC_URI="mirror://mysql/Downloads/Connector-J/${At}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
DEPEND=">=virtual/jdk-1.2
	dev-java/ant
	dev-java/jta
	dev-java/jdbc2-stdext"
RDEPEND=">=virtual/jre-1.2"

S=${WORKDIR}/${At}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f *.jar

	cd lib
	rm -f *.jar
	java-pkg_jar-from jta || die "Failed to link jta"
	java-pkg_jar-from jdbc2-stdext || die "Failed to link jdbc2-stdext"
}

src_compile() {
	local antflags="dist"
	ant ${antflags} || die "build failed!"
}

src_install() {
	cp ${WORKDIR}/build-mysql-jdbc/${At}/${At}-bin.jar ${PN}.jar
	java-pkg_dojar ${PN}.jar
	dodoc README CHANGES COPYING
}

