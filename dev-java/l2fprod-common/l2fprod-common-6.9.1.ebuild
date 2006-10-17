# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/l2fprod-common/l2fprod-common-6.9.1.ebuild,v 1.1 2006/10/17 09:14:52 caster Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java/Swing GUI components and libraries for building desktop applications"
HOMEPAGE="http://common.l2fprod.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	dev-java/ant
	dev-java/jreleaseinfo"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# do not build springrcp and sheet for now, would bloat the deps a lot
	# potential USE flag material (spring, calendars deps)
	epatch "${FILESDIR}/${P}-nodeps.patch"

	cd lib
	java-pkg_jar-from --build-only jreleaseinfo jreleaseinfo.jar jreleaseinfo-1.2.0.jar
}

src_compile() {
	eant init
	java-ant_bsfix_one build/build4components.xml
	eant jar
}

src_install() {
	java-pkg_dojar build/jars/*.jar
	dodoc README.txt
}
