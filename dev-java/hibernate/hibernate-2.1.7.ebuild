# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hibernate/hibernate-2.1.7.ebuild,v 1.5 2005/07/09 22:26:45 swegener Exp $

inherit java-pkg

DESCRIPTION="Hibernate is a powerful, ultra-high performance object / relational persistence and query service for Java."
SRC_URI="mirror://sourceforge/hibernate/${P}c.tar.gz"
HOMEPAGE="http://www.hibernate.org"
LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~x86 ~amd64"
DEPEND=">=virtual/jdk-1.3
		>=dev-java/ant-1.5
		>=dev-java/log4j-1.2.7
		dev-java/dom4j
		dev-java/c3p0
		dev-java/oscache
		dev-java/odmg
		dev-java/commons-logging"
IUSE="doc"

S=${WORKDIR}/${PN}-${PV:0:3}

src_compile() {
	sed -e '/<splash/D' -i ${S}/build.xml
	ant jar
}

src_install() {
	java-pkg_dojar ${WORKDIR}/hibernate/hibernate2.jar lib/cglib*.jar lib/jcs*.jar
	java-pkg_dojar lib/ehcache*.jar lib/swarmcache*.jar lib/proxool*.jar
	java-pkg_dojar lib/concurrent*.jar lib/connector*.jar
	dodoc *.txt
	insinto /usr/share/doc/${P}/sample
	doins src/*.xml src/*.properties src/*.ccf src/META-INF/ra.xml
	use doc && java-pkg_dohtml -r doc/*
}
