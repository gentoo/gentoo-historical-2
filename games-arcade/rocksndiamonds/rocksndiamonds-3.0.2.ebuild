# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/rocksndiamonds/rocksndiamonds-3.0.2.ebuild,v 1.1 2003/09/10 19:29:21 vapier Exp $

inherit games flag-o-matic

DESCRIPTION="A Boulderdash clone"
SRC_URI="http://www.artsoft.org/RELEASES/unix/rocksndiamonds/${P}.tar.gz"
HOMEPAGE="http://www.artsoft.org/rocksndiamonds/"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

DEPEND="X? ( virtual/x11 )
	sdl? ( >=media-libs/libsdl-1.2.3
		>=media-libs/sdl-mixer-1.2.4
		>=media-libs/sdl-image-1.2.2 )
	|| ( X? ( ) sdl? ( ) virtual/x11 )"

src_compile() {
	replace-flags -march=k6 -march=i586

	local makeopts="RO_GAME_DIR=${GAMES_DATADIR}/${PN} RW_GAME_DIR=${GAMES_STATEDIR}/${PN}"
	if [ `use X` ] || [ -z "`use X``use sdl`" ] ; then
		make clean || die
		make ${makeopts} OPTIONS="${CFLAGS}" x11 || die
		mv rocksndiamonds{,.x11}
	fi
	if [ `use sdl` ] ; then
		make clean || die
		make ${makeopts} OPTIONS="${CFLAGS}" sdl || die
		mv rocksndiamonds{,.sdl}
	fi
}

src_install() {
	dogamesbin rocksndiamonds.{sdl,x11}
	dodir ${GAMES_DATADIR}/${PN}
	cp -R graphics levels music sounds ${D}/${GAMES_DATADIR}/${PN}/

	newman rocksndiamonds.{1,6}
	dodoc CHANGES CREDITS HARDWARE README TODO docs/elements/*.txt

	prepgamesdirs
}
