# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-collections/commons-collections-2.1-r3.ebuild,v 1.1 2003/03/18 01:51:25 absinthe Exp $

inherit java-commons

S=${WORKDIR}/${PN}-${PV}-src
DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="http://jakarta.apache.org/commons/collections.html"
SRC_URI="http://jakarta.apache.org/builds/jakarta-commons/release/${PN}/v${PV}/${PN}-${PV}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3
		>=ant-1.4
		junit? ( >=dev-java/junit-3.7 )
		jikes? ( >=dev-java/jikes-1.17 )"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc jikes junit"

src_compile() {
	java-commons_src_compile myconf make 
	use doc && java-commons_src_compile makedoc
}

