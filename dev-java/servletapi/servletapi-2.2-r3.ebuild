# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/servletapi/servletapi-2.2-r3.ebuild,v 1.2 2006/07/21 15:54:08 nichoj Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Servlet API 2.2 from jakarta.apache.org"
HOMEPAGE="http://jakarta.apache.org/"
SRC_URI="mirror://gentoo/${P}-20021101.tar.gz"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.4"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-1.1"
SLOT="2.2"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE="doc"
S="${WORKDIR}/jakarta-servletapi-src"

src_compile() {
	eant all
}

src_install() {
	cd ../dist
	java-pkg_dojar servletapi/lib/servlet.jar || die "Unable to install"

	use doc && java-pkg_dohtml -r servletapi/docs/*

	dodoc dist/README.txt
}
