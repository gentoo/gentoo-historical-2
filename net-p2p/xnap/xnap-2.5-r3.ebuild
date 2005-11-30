# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/xnap/xnap-2.5-r3.ebuild,v 1.1 2004/08/11 17:55:44 squinky86 Exp $

DESCRIPTION="A P2P framework and client"
HOMEPAGE="http://xnap.sf.net"
SRC_URI="mirror://sourceforge/xnap/${P}r2.jar"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE=""
RDEPEND=">=virtual/jre-1.3"

S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/${A} ${WORKDIR}/
}

src_install() {
	mv ${S}/${A} ${S}/${PN}.jar
	insinto /opt/${PN}/lib
	doins ${PN}.jar

	echo "#!/bin/sh" > ${PN}
	echo "cd /opt/${PN}" >> ${PN}
	echo '${JAVA_HOME}'/bin/java -jar lib/${PN}.jar '$*' >> ${PN}

	into /opt
	dobin ${PN}
}

