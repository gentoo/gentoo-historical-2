# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/powermanga/powermanga-0.78.ebuild,v 1.4 2004/06/24 21:58:44 agriffis Exp $

inherit games

DESCRIPTION="An arcade 2D shoot-em-up game"
HOMEPAGE="http://linux.tlk.fr/"
SRC_URI="http://www.tlk.fr/lesjeux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND="virtual/glibc
	>=media-libs/libsdl-0.11.0
	media-libs/sdl-mixer"

src_compile() {
	egamesconf --prefix=/usr || die "egamesconf failed"
	emake || die "emake failed"
}

src_install() {
	local f

	dogamesbin powermanga || die "dogamesbin failed"
	doman powermanga.6
	dodoc AUTHORS CHANGES README

	insinto ${GAMES_DATADIR}/powermanga/sounds
	doins sounds/*

	insinto ${GAMES_DATADIR}/powermanga/graphics
	doins graphics/*

	insinto /var/games
	for f in powermanga.hi-easy powermanga.hi powermanga.hi-hard
	do
		touch ${D}/var/games/${f} || die "touch ${f} failed"
		fperms 660 /var/games/${f} || die "fperms ${f} failed"
	done

	prepgamesdirs
}
