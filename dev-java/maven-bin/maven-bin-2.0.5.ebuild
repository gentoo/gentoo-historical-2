# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/maven-bin/maven-bin-2.0.5.ebuild,v 1.3 2007/04/06 20:29:53 dertobi123 Exp $

# doesn't need to anyherit any java eclasses, since it's not building
# and doesn't use any of the functions

MY_PN=${PN%%-bin}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="mirror://apache/${MY_PN}/binaries/${MY_P}-bin.tar.bz2"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="2.0"
KEYWORDS="~amd64 ppc x86"

RDEPEND=">=virtual/jdk-1.3"

IUSE=""

S="${WORKDIR}/${MY_P}"

MAVEN=${PN}-${SLOT}
MAVEN_SHARE="/usr/share/${MAVEN}"

src_unpack() {
	unpack ${A}

	rm ${S}/bin/*.bat
}

# TODO we should use jars from packages, instead of what is bundled
src_install() {
	dodir ${MAVEN_SHARE}
	cp -Rp bin conf core lib ${D}/${MAVEN_SHARE}

	dodoc NOTICE.txt README.txt

	dodir /usr/bin
	dosym ${MAVEN_SHARE}/bin/mvn /usr/bin/mvn
}
