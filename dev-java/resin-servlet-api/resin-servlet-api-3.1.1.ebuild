# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/resin-servlet-api/resin-servlet-api-3.1.1.ebuild,v 1.1 2007/05/16 10:29:07 nelchael Exp $

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Resin Servlet API 2.5/JSP API 2.1 implementation"
HOMEPAGE="http://www.caucho.com/"
SRC_URI="http://www.caucho.com/download/resin-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="2.5"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/resin-${PV}"

src_unpack() {

	unpack ${A}

	mkdir "${S}/lib"

	cd "${S}"
	epatch "${FILESDIR}/resin-${PV}-gentoo.patch"

}

EANT_BUILD_TARGET="jsdk"
EANT_DOC_TARGET=""

src_install() {

	java-pkg_newjar "lib/jsdk-15.jar"
	use source && java-pkg_dosrc "${S}"/modules/jsdk/src/*

}
