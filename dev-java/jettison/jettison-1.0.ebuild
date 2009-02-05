# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jettison/jettison-1.0.ebuild,v 1.1 2009/02/05 00:22:59 betelgeuse Exp $

EAPI=2
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A JSON StAX implementation"
HOMEPAGE="http://jettison.codehaus.org/"
SRC_URI="http://repository.codehaus.org/org/codehaus/${PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

#Don't need to make one
S="${WORKDIR}"

src_prepare(){
	#no supplied Build file
	cp -v "${FILESDIR}"/build.xml "${S}/build.xml" || die
}

src_install() {
	java-pkg_dojar dist/"${PN}.jar"
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc org
}

