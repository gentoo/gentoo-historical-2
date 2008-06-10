# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/lsdvd/lsdvd-0.16.ebuild,v 1.11 2008/06/10 14:06:57 beandog Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit eutils autotools

DESCRIPTION="Utility for getting info out of DVDs"
HOMEPAGE="http://untrepid.com/lsdvd/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="=media-libs/libdvdread-0.9*"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-types.patch"

	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README
}
