# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/excido/excido-0.1.3.ebuild,v 1.5 2004/04/29 19:54:43 agriffis Exp $

inherit games

DESCRIPTION="A fast paced action game"
HOMEPAGE="http://icculus.org/excido/"
SRC_URI="http://icculus.org/excido/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha"
IUSE=""

DEPEND="dev-games/physfs
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-image"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:\"helmetr.ttf\":\"${GAMES_DATADIR}/${PN}/helmetr.ttf\":" src/Visual.cpp || \
			die "sed Visual.cpp failed"

	sed -i \
		-e "s:\"./data\":\"${GAMES_DATADIR}/${PN}\":" src/main.cpp || \
			die "sed main.cpp failed"

	sed -i \
		-e "s/-Wall .*/${CXXFLAGS}/" Makefile || \
			die "sed Makefile failed"
}

src_install() {
	dogamesbin excido
	dodir ${GAMES_DATADIR}/${PN}
	cp helmetr.ttf data/*.{wav,png} ${D}${GAMES_DATADIR}/${PN}
	dodoc BUGS CHANGELOG HACKING INSTALL README RELNOTES* TODO \
		keyguide.txt data/CREDITS data/*.txt
	prepgamesdirs
}
