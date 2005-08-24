# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/tod/tod-0.ebuild,v 1.2 2005/08/24 03:36:01 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="Tetanus On Drugs simulates playing a Tetris clone under the influence of hallucinogenic drugs"
HOMEPAGE="http://www.pineight.com/tod/"
SRC_URI="http://www.pineight.com/pc/win${PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="media-libs/allegro"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
	sed -i \
		-e "s:idltd\.dat:${GAMES_DATADIR}/${PN}/idltd.dat:" \
		rec.c || die
}

src_compile() {
	emake -f makefile || die "make failed"
}

src_install() {
	newgamesbin tod-debug.exe tod || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins idltd.dat || die
	dodoc readme.txt
}
