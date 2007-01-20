# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/crimson/crimson-1.1.3-r1.ebuild,v 1.2 2007/01/20 20:31:03 corsair Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Apache Crimson XML 1.0 parser"
HOMEPAGE="http://xml.apache.org/crimson/"
SRC_URI="http://xml.apache.org/dist/crimson/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc examples source"

DEPEND="|| ( =virtual/jdk-1.3* =virtual/jdk-1.4* )
	dev-java/ant-core
	source? ( app-arch/zip )"
RDEPEND="|| ( =virtual/jre-1.3* =virtual/jre-1.4* )"

src_compile() {
	eant jars $(use_doc docs)
}

src_install() {
	java-pkg_dojar build/${PN}.jar

	dodoc build/ChangeLog
	java-pkg_dohtml build/README.html
	if use doc; then
		java-pkg_dohtml -r build/docs
		java-pkg_dohtml -r -A class,java,xml build/examples
	fi
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -r examples/* ${D}/usr/share/doc/${PF}/examples
	fi
	use source && java-pkg_dosrc src/javax src/org
}
