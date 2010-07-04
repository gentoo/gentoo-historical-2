# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libtorrent/libtorrent-0.12.6.ebuild,v 1.6 2010/07/04 13:22:34 ssuominen Exp $

EAPI=2
inherit eutils libtool

DESCRIPTION="LibTorrent is a BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="debug ipv6 ssl"

RDEPEND=">=dev-libs/libsigc++-2.2.2:2
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc44.patch
	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		--with-posix-fallocate
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}
