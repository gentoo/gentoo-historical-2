# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-cli/commons-cli-1.0-r2.ebuild,v 1.6 2004/04/05 05:34:37 zx Exp $

inherit jakarta-commons

DESCRIPTION="The CLI library provides a simple and easy to use API for working with the command line arguments and options."
HOMEPAGE="http://jakarta.apache.org/commons/cli/"
SRC_URI="mirror://apache/jakarta/commons/cli/source/cli-${PV}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3
		>=dev-java/ant-1.4"
RDEPEND=">=virtual/jdk-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 sparc ppc"
IUSE="doc jikes junit"

src_compile() {
	patch -d ${S} -p0 < ${FILESDIR}/${PN}-${PV}-gentoo.diff || die "Could not correct version in build.xml"
	jakarta-commons_src_compile myconf make
	use doc && jakarta-commons_src_compile makedoc
}

