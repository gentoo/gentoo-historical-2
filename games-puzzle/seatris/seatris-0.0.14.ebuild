# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/seatris/seatris-0.0.14.ebuild,v 1.3 2004/12/21 14:32:21 nigoro Exp $

inherit games

DESCRIPTION="A color ncurses tetris clone"
HOMEPAGE="http://www.earth.li/projectpurple/progs/seatris.html"
SRC_URI="http://www.earth.li/projectpurple/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~ppc64"
IUSE=""

DEPEND="virtual/libc
	sys-libs/ncurses"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:/var/lib/games:${GAMES_STATEDIR}:" \
		scoring.h seatris.6 \
		|| die "sed failed"
}

src_install () {
	dogamesbin seatris
	doman seatris.6
	dodoc ACKNOWLEDGEMENTS HISTORY README TODO example.seatrisrc
	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}/seatris.score"
	fperms 660 ${GAMES_STATEDIR}/seatris.score
	prepgamesdirs
}
