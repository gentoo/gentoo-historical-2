# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/rocksndiamonds/rocksndiamonds-3.0.8.ebuild,v 1.2 2004/04/05 22:19:11 vapier Exp $

inherit flag-o-matic games

DESCRIPTION="A Boulderdash clone"
HOMEPAGE="http://www.artsoft.org/rocksndiamonds/"
SRC_URI="http://www.artsoft.org/RELEASES/unix/rocksndiamonds/${P}.tar.gz
	http://www.artsoft.org/RELEASES/rocksndiamonds/levels/BD2K3-1.0.0.zip
	http://www.jb-line.de/rnd_jue-v5.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE="X sdl"

DEPEND="virtual/glibc
	X? ( virtual/x11 )
	!sdl? ( virtual/x11 )
	sdl? ( >=media-libs/libsdl-1.2.3
		>=media-libs/sdl-mixer-1.2.4
		>=media-libs/sdl-image-1.2.2 )"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}/levels
	unpack rnd_jue-v5.zip
	unpack BD2K3-1.0.0.zip
}

src_compile() {
	replace-cpu-flags i586 k6 k6-1 k6-2

	local makeopts="RO_GAME_DIR=${GAMES_DATADIR}/${PN} RW_GAME_DIR=${GAMES_STATEDIR}/${PN}"
	if use X || { ! use X && ! use sdl; } ; then
		make clean || die
		make ${makeopts} OPTIONS="${CFLAGS}" x11 || die
		mv rocksndiamonds{,.x11}
	fi
	if use sdl ; then
		make clean || die
		make ${makeopts} OPTIONS="${CFLAGS}" sdl || die
		mv rocksndiamonds{,.sdl}
	fi
}

src_install() {
	dogamesbin rocksndiamonds.{sdl,x11} || die
	dodir ${GAMES_DATADIR}/${PN}
	cp -R graphics levels music sounds ${D}/${GAMES_DATADIR}/${PN}/

	newman rocksndiamonds.{1,6}
	dodoc CHANGES CREDITS HARDWARE README TODO docs/elements/*.txt

	prepgamesdirs
}
