# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jcommon/jcommon-1.0.8.ebuild,v 1.1 2007/02/10 00:45:56 fordfrog Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 versionator

DESCRIPTION="JCommon is a collection of useful classes used by JFreeChart, JFreeReport and other projects."
HOMEPAGE="http://www.jfree.org"
MY_P=${PN}-$(replace_version_separator 3 -)
SRC_URI="mirror://sourceforge/jfreechart/${MY_P}.tar.gz"
LICENSE="LGPL-2"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"
DEPEND=">=virtual/jdk-1.4
		dev-java/ant-core"
RDEPEND=">=virtual/jdk-1.4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm *.jar ${S}/lib/*.jar
}

src_compile() {
	if ! use debug; then
		antflags="-Dbuild.debug=false -Dbuild.optimize=true"
	fi
	eant -f ant/build.xml compile $(use_doc) $antflags
}

src_install() {
	java-pkg_newjar ${P}.jar ${PN}.jar
	dodoc README.txt
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc source/com source/org
}
