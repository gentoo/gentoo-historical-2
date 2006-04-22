# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lomoco/lomoco-1.0.ebuild,v 1.2 2006/04/22 10:28:18 hollow Exp $

inherit autotools

DESCRIPTION="Lomoco can configure vendor-specific options on Logitech USB mice \
(or dual-personality mice plugged into the USB port). Visit the website for \
specific available options."
HOMEPAGE="http://lomoco.linux-gamers.net/"
SRC_URI="http://lomoco.linux-gamers.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/libusb"

src_compile() {
	eautoreconf
	econf
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
