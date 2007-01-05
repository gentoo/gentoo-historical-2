# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/gngeo/gngeo-0.7.ebuild,v 1.3 2007/01/05 20:17:57 nyhm Exp $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit eutils autotools games

DESCRIPTION="A NeoGeo emulator"
HOMEPAGE="http://m.peponas.free.fr/gngeo/"
SRC_URI="http://download.berlios.de/gngeo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="virtual/opengl
	media-libs/sdl-image
	media-libs/libsdl"
DEPEND="${RDEPEND}
	x86? ( >=dev-lang/nasm-0.98 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-execstacks.patch \
		"${FILESDIR}"/${P}-concurrentMake.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS FAQ NEWS README* TODO sample_gngeorc
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "A licensed NeoGeo BIOS copy is required to run the emulator."
	echo
}
