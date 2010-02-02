# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libjwc_c/libjwc_c-1.1-r1.ebuild,v 1.1 2010/02/02 20:58:46 jlec Exp $

EAPI="2"

inherit autotools eutils

PATCH="612"

DESCRIPTION="additional c library for ccp4"
HOMEPAGE="http://www.ccp4.ac.uk/main.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/jwc/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PATCH}-gentoo.patch
	rm missing || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README NEWS || die
}
