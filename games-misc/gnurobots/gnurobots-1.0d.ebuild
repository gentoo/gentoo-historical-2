# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/gnurobots/gnurobots-1.0d.ebuild,v 1.5 2004/12/28 18:14:19 josejx Exp $

inherit games

MY_P="${PN}-${PV/d/D}"
DESCRIPTION="Game/diversion where you construct a program for a little robot then set him loose and watch him explore a world on his own"
HOMEPAGE="http://www.gnu.org/directory/games/gnurobots.html"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="X"

S=${WORKDIR}/${MY_P}

DEPEND="X? ( virtual/x11 )
	dev-util/guile"

src_compile() {
	egamesconf || die
	emake || die
}

src_install() {
	dogamesbin src/{robots,xrobots,robots_logfile}

	insinto ${GAMES_DATADIR}/${PN}/scheme
	doins scheme/*.scm
	insinto ${GAMES_DATADIR}/${PN}/maps
	doins maps/*.map

	dodoc doc/*

	prepgamesdirs
}
