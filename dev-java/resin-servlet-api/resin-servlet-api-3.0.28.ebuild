# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/resin-servlet-api/resin-servlet-api-3.0.28.ebuild,v 1.1 2009/06/28 10:41:41 nelchael Exp $

EAPI="2"

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Resin Servlet API 2.4/JSP API 2.0 implementation"
HOMEPAGE="http://www.caucho.com/"
SRC_URI="http://www.caucho.com/download/resin-${PV}-src.zip
	mirror://gentoo/resin-gentoo-patches-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="2.4"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/resin-${PV}"

src_prepare() {
	mkdir "${S}/lib"
	epatch "${WORKDIR}/${PV}/resin-${PV}-build.xml.patch"
}

EANT_BUILD_TARGET="jsdk"
EANT_DOC_TARGET=""

src_install() {
	java-pkg_newjar "lib/jsdk-24.jar"
	use source && java-pkg_dosrc "${S}"/modules/jsdk/src/*

	dosym "${PN}.jar" "/usr/share/${PN}-${SLOT}/lib/servlet-api.jar"
	java-pkg_regjar "${D}/usr/share/${PN}-${SLOT}/lib/servlet-api.jar"
	dosym "${PN}.jar" "/usr/share/${PN}-${SLOT}/lib/jsp-api.jar"
	java-pkg_regjar "${D}/usr/share/${PN}-${SLOT}/lib/jsp-api.jar"
}
