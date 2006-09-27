# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/defendguin/defendguin-0.0.10.ebuild,v 1.8 2006/09/27 18:25:49 nyhm Exp $

inherit eutils games
DESCRIPTION="A clone of the arcade game Defender, but with a Linux theme"
HOMEPAGE="http://www.newbreedsoftware.com/defendguin/"
SRC_URI="ftp://ftp.sonic.net/pub/users/nbs/unix/x/defendguin/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="media-libs/sdl-mixer
	media-libs/libsdl"

pkg_setup() {
	if ! built_with_use media-libs/sdl-mixer mikmod; then
		die "You need to build media-libs/sdl-mixer with mikmod USE flag enabled!"
	fi
	games_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-makefile.patch"
	rm -f data/images/*.sh
}

src_install() {
	dogamesbin defendguin || die "dogamesbin failed"
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r ./data/* "${D}/${GAMES_DATADIR}/${PN}" || die "cp failed"
	prepgamesdirs
}
