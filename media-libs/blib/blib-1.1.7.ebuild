# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/blib/blib-1.1.7.ebuild,v 1.1 2005/05/16 10:37:51 luckyduck Exp $

DESCRIPTION="blib is a library full of useful things to hack the Blinkenlights"
HOMEPAGE="http://www.blinkenlights.de"
SRC_URI="http://www.blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="aalib gtk2 directfb"

RDEPEND="dev-libs/glib
	aalib? ( >=media-libs/aalib-1.4_rc4-r2 )
	directfb? ( >=dev-libs/DirectFB-0.9.20-r1 )
	gtk2? ( >=x11-libs/gtk+-2.4.4 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
		$(use_enable aalib) \
		$(use_enable directfb) \
		$(use_enable gtk2) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README
}
