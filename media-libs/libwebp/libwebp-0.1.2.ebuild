# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libwebp/libwebp-0.1.2.ebuild,v 1.5 2011/06/07 17:25:57 hwoarang Exp $

EAPI=4
inherit autotools

DESCRIPTION="A lossy image compression format"
HOMEPAGE="http://code.google.com/p/webp/"
SRC_URI="http://webp.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~x86"
IUSE="static-libs"

RDEPEND=">=media-libs/libpng-1.4
	virtual/jpeg"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-dependency-tracking
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f {} +
}
