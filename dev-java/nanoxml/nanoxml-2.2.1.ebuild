# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/nanoxml/nanoxml-2.2.1.ebuild,v 1.1.1.1 2005/11/30 09:47:16 chriswhite Exp $

inherit java-pkg

DESCRIPTION="NanoXML is a small non-validating parser for Java. "

HOMEPAGE="http://nanoxml.sourceforge.net/"
MY_P=NanoXML-${PV}
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="doc"
DEPEND=">=virtual/jdk-1.3
		${RDEPEND}"
RDEPEND=">=virtual/jre-1.3
		dev-java/sax"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}/ThirdParty/SAX
	java-pkg_jar-from sax
	cd ${S}
	sed -e "s:/tmp/:${T}:g" -i build.sh || die "failed to sed"
}

src_compile() {
	./build.sh || die "failed to build"
}

src_install() {
	java-pkg_dojar Output/*.jar

	use doc && java-pkg_dohtml -r Documentation/*
}
