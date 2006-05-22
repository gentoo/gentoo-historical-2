# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/gamepick/gamepick-0.35.ebuild,v 1.1 2006/05/22 18:01:58 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="Launch opengl games with custom graphic settings"
HOMEPAGE="http://www.rillion.net/gamepick/index.html"
SRC_URI="http://www.rillion.net/gamepick/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="=x11-libs/gtk+-2*"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-paths.patch
	sed -i \
		-e "s:GAMES_CONFDIR:${GAMES_SYSCONFDIR}:" \
		-e "s:GAMES_BINDIR:${GAMES_BINDIR}:" \
		-e "s:GAMES_DATADIR:${GAMES_DATADIR}/${PN}:" \
		load_lists.c gamepick.h
	sed -i \
		-e "/^flags/s:-Wall -Werror -pedantic -c -g:-c ${CFLAGS}:" \
		Makefile
}

src_install() {
	dogamesbin gamepick gamepick-stage{2,3} || die "dogamesbin"
	dodoc ABOUT README TODO
	insinto "${GAMES_SYSCONFDIR}"
	doins gamepick.conf
	insinto "${GAMES_DATADIR}"/${PN}
	doins *.png *.xpm *.gif
	prepgamesdirs
}
