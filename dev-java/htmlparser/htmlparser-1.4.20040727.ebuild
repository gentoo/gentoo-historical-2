# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/htmlparser/htmlparser-1.4.20040727.ebuild,v 1.5 2005/02/06 01:45:30 luckyduck Exp $

inherit java-pkg

DESCRIPTION="HTML Parser is a Java library used to parse HTML in either a linear or nested fashion."

HOMEPAGE="http://htmlparser.sourceforge.net/"
MY_P=${P/-}
MY_P=${MY_P//./_}
SRC_URI="mirror://sourceforge/htmlparser/${MY_P}.zip"
LICENSE="LGPL-2.1"
SLOT="${PV}"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="doc"
DEPEND="virtual/jdk
		app-arch/unzip
		dev-java/ant"
#RDEPEND=""

S=${WORKDIR}/${MY_P%_*}

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
	java-pkg_dojar lib/{htmllexer.jar,htmlparser.jar}
	dodoc readme.txt
	use doc && java-pkg_dohtml -r docs/
}
