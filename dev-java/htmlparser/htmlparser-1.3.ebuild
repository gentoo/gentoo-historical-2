# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/htmlparser/htmlparser-1.3.ebuild,v 1.1 2004/09/17 09:40:23 axxo Exp $

inherit java-pkg

DESCRIPTION="HTML Parser is a Java library used to parse HTML in either a linear or nested fashion."

HOMEPAGE="http://htmlparser.sourceforge.net/"
MY_P=${P/-}
MY_P=${MY_P//./_}
SRC_URI="mirror://sourceforge/htmlparser/${MY_P}.zip"
LICENSE="LGPL-2.1"
SLOT="${PV}"
KEYWORDS="~x86"
IUSE="doc"
DEPEND="virtual/jdk
		app-arch/unzip
		dev-java/ant"
#RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf lib docs
	unzip src.zip
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags} || die "failed to compile"
}

src_install() {
	java-pkg_dojar release/${MY_P}/lib/htmlparser.jar
	dodoc readme.txt
	use doc && dohtml -r docs/
}
