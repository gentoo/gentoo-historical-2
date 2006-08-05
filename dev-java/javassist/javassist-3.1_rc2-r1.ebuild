# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javassist/javassist-3.1_rc2-r1.ebuild,v 1.1 2006/08/05 17:14:25 nichoj Exp $

inherit java-pkg-2 java-ant-2

MY_PV=${PV/_rc/RC}
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Javassist makes Java bytecode manipulation simple."
SRC_URI="mirror://sourceforge/jboss/${MY_P}.zip"
HOMEPAGE="http://www.csg.is.titech.ac.jp/~chiba/javassist/"

LICENSE="MPL-1.1"
SLOT="3.1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip
		>=dev-java/ant-core-1.5
		source? ( app-arch/zip )"
S="${WORKDIR}/${MY_P}"

src_compile() {
	eant clean jar $(use_doc javadocs)
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dohtml Readme.html
	use doc && java-pkg_dojavadoc html
	use source && java-pkg_dosrc src/main/javassist
}
