# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libtorrent/libtorrent-0.3.2.ebuild,v 1.4 2004/08/30 15:47:26 dholm Exp $

DESCRIPTION="LibTorrent is a BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

IUSE="ncurses"

RDEPEND="dev-libs/openssl
	net-misc/curl
	>=dev-libs/libsigc++-2
	ncurses? ( >=sys-libs/ncurses-5.4 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.11"

src_unpack() {
	unpack ${A}
	cd ${S}
	use ncurses && cp client/Makefile2 client/Makefile
}

src_compile() {
	econf || die
	emake || die
	use ncurses && emake -C client || die
}

src_install() {
	einstall || die
	use ncurses && dobin client/rtorrent
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TODO
	use ncurses && newdoc client/README README.rtorrent
}
