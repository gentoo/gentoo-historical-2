# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/xbomber/xbomber-101.ebuild,v 1.6 2005/05/03 07:56:56 dholm Exp $

inherit games

DESCRIPTION="Bomberman clone w/multiplayer support"
HOMEPAGE="http://www.xdr.com/dash/bomber.html"
SRC_URI="http://www.xdr.com/dash/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

RDEPEND="virtual/x11"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i "s:X386:X11R6:" Makefile
	sed -i "s:data/%s:${GAMES_DATADIR}/${PN}/%s:" bomber.c
	sed -i "s:=\"data\":=\"${GAMES_DATADIR}/${PN}\":" sound.c
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	dogamesbin matcher bomber
	dodir ${GAMES_DATADIR}/${PN}
	cp -r data/* ${D}/${GAMES_DATADIR}/${PN}/
	dodoc README Changelog
	prepgamesdirs
}
