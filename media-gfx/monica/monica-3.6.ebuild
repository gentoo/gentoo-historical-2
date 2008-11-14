# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/monica/monica-3.6.ebuild,v 1.2 2008/11/14 20:59:15 robbat2 Exp $

inherit eutils

DESCRIPTION="Monica is a Monitor Calibration Tool"
HOMEPAGE="http://www.pcbypaul.com/software/monica.html"
SRC_URI="http://www.pcbypaul.com/software/dl/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
DEPEND="<x11-libs/fltk-2"
RDEPEND="x11-apps/xgamma
		 ${DEPEND}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-makefile-cleanup.patch
	cd "${S}"
	make clean
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin monica
	dodoc AUTHORS ChangeLog NEWS README
}
