# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/neverball/neverball-0.25.9.ebuild,v 1.1 2003/10/13 22:37:38 vapier Exp $

inherit games

DATA="${GAMES_DATADIR}/${PN}/data"
DESCRIPTION="Clone of Super Monkey Ball using SDL/OpenGL"
HOMEPAGE="http://aoeu.snth.net/neverball/"
SRC_URI="http://aoeu.snth.net/neverball/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND=">=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2.5
	>=media-libs/sdl-image-1.2.2
	media-libs/sdl-ttf
	virtual/glut"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i "s:\"./data\":\"${DATA}\":g" \
		config.h \
		|| die "sed config.h failed"
	sed -i \
		-e "s:-Wall -g:${CFLAGS}:" \
		-e "s:^include:-include:" \
		Makefile \
		|| die "sed Makefile failed"
}

src_install() {
	dogamesbin neverball
	dogamesbin mapc

	rm -f data/Makefile*
	dodir ${DATA}
	cp -R ${S}/data/* ${D}/${DATA}/

	dodoc CHANGES MAPPING README
	prepgamesdirs
}
