# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hibernate/hibernate-2.1.6.ebuild,v 1.1 2004/08/11 14:47:35 voxus Exp $

inherit java-pkg

DESCRIPTION="Hibernate is a powerful, ultra-high performance object / relational persistence and query service for Java."
SRC_URI="mirror://sourceforge/hibernate/${PN}-${PV}.tar.gz"
HOMEPAGE="http://hibernate.bluemars.net"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
DEPEND=">=virtual/jdk-1.3
		>=dev-java/ant-1.5
		>=dev-java/log4j-1.2.7
		dev-java/dom4j
		dev-java/commons-logging"
IUSE="doc"

S=${WORKDIR}/${PN}-${PV:0:3}

src_compile() {
	sed -e '/<splash/D' -i ${S}/build.xml
	ant jar
}

src_install() {
	java-pkg_dojar ${WORKDIR}/hibernate/hibernate2.jar lib/cglib*.jar lib/jcs*.jar lib/odmg*.jar lib/c3p0*.jar
	java-pkg_dojar lib/ehcache*.jar lib/swarmcache*.jar lib/oscache*.jar lib/proxool*.jar
	java-pkg_dojar lib/concurrent*.jar lib/connector*.jar
	dodoc *.txt lib/c3p0*.txt
	insinto /usr/share/doc/${P}/sample
	doins src/*.xml src/*.properties src/*.ccf src/META-INF/ra.xml
	use doc && dohtml -r doc/*
}
