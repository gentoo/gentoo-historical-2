# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/galib/galib-2.4.6.ebuild,v 1.2 2005/09/21 15:30:17 phosphan Exp $

inherit eutils

DESCRIPTION="library for using genetic algorithms in C++ programs"

MYPV="${PV//\./}"

HOMEPAGE="http://lancet.mit.edu/ga/"
SRC_URI="http://lancet.mit.edu/ga/dist/galib${MYPV}.tgz"
LICENSE="GAlib"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

S="${WORKDIR}/galib${MYPV}"

src_compile() {
	make CXXFLAGS="${CXXFLAGS}" || die "make failed"
}

src_install() {
	dodir /usr/lib /usr/include
	make LIB_DEST_DIR=${D}/usr/lib/ HDR_DEST_DIR=${D}/usr/include/ install || die
	dohtml -r doc/*
	dodoc RELEASE-NOTES README
	cp -r examples ${D}/usr/share/doc/${PF}/
}
