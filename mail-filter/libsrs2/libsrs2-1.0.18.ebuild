# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/libsrs2/libsrs2-1.0.18.ebuild,v 1.7 2011/09/12 00:04:38 radhermit Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="libsrs2 is the next generation Sender Rewriting Scheme library"
HOMEPAGE="http://www.libsrs2.org/"
SRC_URI="http://www.libsrs2.org/srs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}/${P}-parallel-make.diff"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${D}" -name '*.la' -delete
}
