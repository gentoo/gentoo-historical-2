# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-looks-bin/jgoodies-looks-bin-1.2.1.ebuild,v 1.1 2004/05/14 20:19:54 zx Exp $

inherit java-pkg

DESCRIPTION="java look&feel from Karsten Lentzsch"
HOMEPAGE="http://www.jgoodies.com"
SRC_URI="http://www.jgoodies.com/download/libraries/looks-${PV//./_}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jdk-1.4"
S=${WORKDIR}

src_compile() { :; }

src_install() {
	java-pkg_dojar looks-1.2.1/{looks-${PV}.jar,looks-win-${PV}.jar,plastic-${PV}.jar}
	dodoc looks-1.2.1/{README.html,RELEASE-NOTES.txt}
	use doc && dohtml -r looks-1.2.1/docs/*
}
