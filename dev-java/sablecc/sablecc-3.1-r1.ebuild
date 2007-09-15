# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sablecc/sablecc-3.1-r1.ebuild,v 1.4 2007/09/15 10:11:39 rbu Exp $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java based compiler / parser generator"
HOMEPAGE="http://www.sablecc.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

src_unpack() {
	unpack "${A}"
	rm -v "${S}"/lib/*.jar || die
}

JAVA_PKG_FILTER_COMPILER="jikes"

src_install() {
	java-pkg_dojar lib/*

	dobin ${FILESDIR}/${PN}

	dodoc AUTHORS THANKS || die
	dohtml README.html || die
	use source && java-pkg_dosrc src/*
}
