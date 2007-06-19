# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xml-commons-resolver/xml-commons-resolver-1.2.ebuild,v 1.5 2007/06/19 07:41:55 opfer Exp $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="An XML Entity and URI Resolver"
HOMEPAGE="http://xml.apache.org/commons/"
SRC_URI="mirror://apache/xml/commons/${P}.tar.gz"
DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE=""

JAVA_PKG_BSFIX_NAME="resolver.xml"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -rf apidocs resolver.jar || die
}

EANT_BUILD_XML="resolver.xml"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar build/resolver.jar

	dodoc KEYS LICENSE.resolver.txt NOTICE-resolver.txt || die
	if use doc; then
		java-pkg_dojavadoc build/apidocs/resolver
		java-pkg_dohtml docs/*.html
	fi

	use source && java-pkg_dosrc src/org
}
