# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ta-lib/ta-lib-0.4.0.ebuild,v 1.4 2008/01/20 21:50:17 drac Exp $

inherit eutils

DESCRIPTION="Technical Analysis Library for analyzing financial markets trends"
HOMEPAGE="http://www.ta-lib.org"
SRC_URI="mirror://sourceforge/ta-lib/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-asneeded.patch
}

src_test() {
	ewarn "Note: this testsuite will fail without an active internet connection."
	"${S}"/src/tools/ta_regtest/ta_regtest || die "Failed testsuite."
}

src_install(){
	emake DESTDIR="${D}" install || die "install failed"
}
