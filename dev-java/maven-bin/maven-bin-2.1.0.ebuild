# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/maven-bin/maven-bin-2.1.0.ebuild,v 1.2 2009/10/26 08:01:29 volkmar Exp $

inherit java-pkg-2

MY_PN=apache-${PN%%-bin}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="mirror://apache/maven/binaries/${MY_P}-bin.tar.bz2"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=virtual/jdk-1.4
	app-admin/eselect-maven"

IUSE=""

S="${WORKDIR}/${MY_P}"

MAVEN=${PN}-${SLOT}
MAVEN_SHARE="/usr/share/${MAVEN}"

src_unpack() {
	unpack ${A}

	rm -v "${S}"/bin/*.bat || die
}

# TODO we should use jars from packages, instead of what is bundled
src_install() {
	dodir "${MAVEN_SHARE}"
	cp -Rp bin boot conf lib "${D}/${MAVEN_SHARE}" || die "failed to copy"

	java-pkg_regjar "${D}/${MAVEN_SHARE}"/lib/*.jar

	dodoc NOTICE.txt README.txt || die

	dodir /usr/bin
	dosym "${MAVEN_SHARE}/bin/mvn" /usr/bin/mvn-${SLOT}
}
