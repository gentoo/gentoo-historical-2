# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/mudix/mudix-4.0.ebuild,v 1.5 2004/11/05 05:27:16 josejx Exp $

DESCRIPTION="A small, stable MUD client for the console"
HOMEPAGE="http://dwizardry.dhs.org/mudix.html"
SRC_URI="http://dwizardry.dhs.org/mudix/${P}.tar.gz"

KEYWORDS="x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/libc
	>=sys-libs/ncurses-5.2"

src_compile() {
	./configure --host=${CHOST} \
		--prefix=/usr --sysconfdir=/etc \
		--localstatedir=/var/lib || die

	emake || die "emake failed"
}

src_install () {
	dobin mudix
	dodoc README sample.usr
}
