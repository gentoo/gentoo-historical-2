# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/resin-servlet-api/resin-servlet-api-4.0.5.3.0.ebuild,v 1.1 2010/04/02 12:38:10 nelchael Exp $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 versionator

MY_PV="$(get_version_component_range 1-3)"

DESCRIPTION="Resin Servlet API 3.0/JSP API 2.1 implementation"
HOMEPAGE="http://www.caucho.com/"
SRC_URI="http://www.caucho.com/download/resin-${MY_PV}-src.zip"

LICENSE="GPL-2"
SLOT="3.0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/resin-${MY_PV}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	java-ant_bsfix_files build-common.xml || die
}

EANT_BUILD_TARGET="servlet16"
EANT_DOC_TARGET=""

src_install() {
	java-pkg_newjar "modules/servlet16/dist/servlet-16.jar"
	use source && java-pkg_dosrc "${S}"/modules/servlet16/src/*

	dosym "${PN}.jar" "/usr/share/${PN}-${SLOT}/lib/servlet-api.jar"
	java-pkg_regjar "${D}/usr/share/${PN}-${SLOT}/lib/servlet-api.jar"
	dosym "${PN}.jar" "/usr/share/${PN}-${SLOT}/lib/jsp-api.jar"
	java-pkg_regjar "${D}/usr/share/${PN}-${SLOT}/lib/jsp-api.jar"
}
