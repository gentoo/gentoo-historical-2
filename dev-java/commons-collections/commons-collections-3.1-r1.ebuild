# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-collections/commons-collections-3.1-r1.ebuild,v 1.2 2006/07/21 15:33:03 nichoj Exp $

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="http://jakarta.apache.org/commons/collections/"
SRC_URI="mirror://apache/jakarta/commons/collections/source/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~amd64 ~ppc64"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.3
	dev-java/ant-core
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.3"

src_compile() {
	eant $(use_doc) jar
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar

	dodoc README.txt
	java-pkg_dohtml *.html
	use doc && java-pkg_dohtml -r build/docs/apidocs
	use source && java-pkg_dosrc src/java/*
}
