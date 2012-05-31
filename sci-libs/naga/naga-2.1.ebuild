# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/naga/naga-2.1.ebuild,v 1.1 2012/05/31 20:50:17 je_fro Exp $
EAPI=4

inherit subversion java-pkg-2 java-ant-2

ESVN_REPO_URI="http://naga.googlecode.com/svn/trunk@57"
MY_PV=${PV//./_}
MY_PVR="${MY_PV}-r43"

DESCRIPTION="Simplified Java NIO asynchronous sockets"
HOMEPAGE="http://code.google.com/p/naga/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.5"

src_compile() {
	eant build
}

src_install() {
	java-pkg_newjar _DIST/${PN}-${MY_PVR}.jar ${PN}.jar
}
