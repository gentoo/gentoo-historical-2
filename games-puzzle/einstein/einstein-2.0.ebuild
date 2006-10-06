# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/einstein/einstein-2.0.ebuild,v 1.4 2006/10/06 18:18:36 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="A puzzle game inspired by Albert Einstein"
HOMEPAGE="http://games.flowix.com/en/"
SRC_URI="http://games.flowix.com/files/einstein/${P}-src.tar.gz
	mirror://gentoo/${PN}.png
	http://dev.gentoo.org/~wolf31o2/sources/dump/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl
		media-libs/sdl-mixer
		media-libs/sdl-ttf"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-64bit.patch
	sed -i \
		-e "/PREFIX/s:/usr/local:${GAMES_PREFIX}:" \
		-e "s:\$(PREFIX)/share/einstein:${GAMES_DATADIR}/${PN}:" \
		-e "s:\$(PREFIX)/bin:${GAMES_BINDIR}:" \
		-e "s/\(OPTIMIZE=[^#]*\)/\0 ${CXXFLAGS}/" Makefile \
		|| die "sed Makefile failed"
	sed -i \
		-e "s:PREFIX L\"/share/einstein:L\"${GAMES_DATADIR}/${PN}:" main.cpp \
		|| die "sed main.cpp failed"
}

src_install() {
	dogamesbin "${PN}" || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}/res"
	doins einstein.res || die "doins failed"
	doicon ${DISTDIR}/${PN}.png
	make_desktop_entry ${PN} "Einstein Puzzle"
	prepgamesdirs
}
