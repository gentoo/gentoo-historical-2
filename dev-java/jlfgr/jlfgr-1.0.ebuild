# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jlfgr/jlfgr-1.0.ebuild,v 1.2 2004/10/06 22:13:20 axxo Exp $

inherit java-pkg

DESCRIPTION="Java(TM) Look and Feel Graphics Repository"

HOMEPAGE="http://java.sun.com/developer/techDocs/hi/repository/"
SRC_URI="mirror://gentoo/jlfgr-1_0.zip"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"
IUSE=""
DEPEND=""
RDEPEND=""
RESTRICT="fetch"
S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mv jlfgr-1_0.jar ${PN}.jar
}

src_compile() { :; }

src_install() {
	java-pkg_dojar ${PN}.jar
}
