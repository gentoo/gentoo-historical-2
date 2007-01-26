# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jakarta-oro/jakarta-oro-2.0.8-r2.ebuild,v 1.10 2007/01/26 05:55:29 beandog Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="A set of text-processing Java classes."
HOMEPAGE="http://jakarta.apache.org/oro/index.html"
SRC_URI="mirror://apache/jakarta/oro/source/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="2.0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd"
IUSE="doc examples source"

DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-core-1.4
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.3"

src_compile() {
	eant $(use_doc javadocs) jar
}

src_install() {
	java-pkg_newjar ${PN}*.jar

	if use doc; then
		dodoc CHANGES COMPILE CONTRIBUTORS ISSUES README STYLE TODO
		java-pkg_dohtml *.html
		java-pkg_dohtml -r docs/
	fi
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -r src/java/examples/* ${D}/usr/share/doc/${PF}/examples
	fi
	use source && java-pkg_dosrc src/java/org
}
