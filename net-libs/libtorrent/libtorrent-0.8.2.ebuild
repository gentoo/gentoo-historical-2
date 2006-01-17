# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libtorrent/libtorrent-0.8.2.ebuild,v 1.2 2006/01/17 09:14:46 flameeyes Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="LibTorrent is a BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="debug"

RDEPEND=">=dev-libs/libsigc++-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.11"

src_compile() {
	[[ $(tc-arch) = "x86" ]] && filter-flags -fomit-frame-pointer
	replace-flags -Os -O2

	econf \
		$(use_enable debug) \
		--disable-dependency-tracking \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
