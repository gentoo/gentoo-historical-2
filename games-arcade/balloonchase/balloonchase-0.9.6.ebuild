# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/balloonchase/balloonchase-0.9.6.ebuild,v 1.4 2004/06/24 22:01:44 agriffis Exp $

inherit games

DESCRIPTION="Fly a hot air balloon and try to blow the other player out of the screen"
HOMEPAGE="http://koti.mbnet.fi/makegho/c/bchase/"
SRC_URI="http://koti.mbnet.fi/makegho/c/bchase/${P}.tar.bz2"

KEYWORDS="x86 ~amd64"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-libs/libsdl"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e '/opendir/ i\	if (getenv("HOME")) { chdir(getenv("HOME")); }
			' \
		-e 's:balloonchase.dat:.balloonchaserc:ig' \
		-e "s:\"images/:\"${GAMES_DATADIR}/${PN}/images/:" src/main.c || \
			die 'sed main.c failed'
	sed -i \
		-e "/^CFLAGS/ s:=.*:= ${CFLAGS}:" Makefile || \
			die 'sed Makefile failed'
}

src_install() {
	dogamesbin balloonchase                     || die "dogamesbin failed"
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r images "${D}/${GAMES_DATADIR}/${PN}/" || die "cp failed"
	dodoc README                                || die "dodoc failed"
	prepgamesdirs
}
