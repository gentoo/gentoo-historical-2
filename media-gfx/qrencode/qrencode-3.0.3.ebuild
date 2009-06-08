# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/qrencode/qrencode-3.0.3.ebuild,v 1.2 2009/06/08 19:12:47 fauli Exp $

DESCRIPTION="C library for encoding data in a QR Code symbol"
HOMEPAGE="http://megaui.net/fukuchi/works/qrencode/index.en.html"
SRC_URI="http://megaui.net/fukuchi/works/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libpng
	media-libs/libsdl"

src_compile() {
	econf || die "configure failed"
	# not parallel make safe
	emake -j1 || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc README TODO NEWS ChangeLog
}
