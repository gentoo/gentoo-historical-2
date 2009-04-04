# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/zeus-jscl/zeus-jscl-1.60.ebuild,v 1.1 2009/04/04 18:34:24 weaver Exp $

EAPI=2

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Zeus Java Swing Components Library"
HOMEPAGE="http://sourceforge.net/projects/zeus-jscl/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_v${MY_PV}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=""
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}_v${MY_PV}"

src_install() {
	java-pkg_newjar lib/${P}.jar ${PN}.jar
	use source && java-pkg_dosrc src
	use doc && java-pkg_dodoc doc
}
