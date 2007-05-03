# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fastutil/fastutil-4.3.1-r1.ebuild,v 1.1 2007/05/03 12:40:24 nelchael Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provides type-specific maps, sets and lists with a small memory footprint for much faster access and insertion."
SRC_URI="http://fastutil.dsi.unimi.it/${P}-src.tar.gz"
HOMEPAGE="http://fastutil.dsi.unimi.it"
LICENSE="LGPL-2.1"
SLOT="4.3"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

src_compile() {

	emake sources || die "failed to make sources"

	java-pkg-2_src_compile

}

src_install() {

	java-pkg_newjar ${P}.jar

	dodoc CHANGES README
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc java/it

}
