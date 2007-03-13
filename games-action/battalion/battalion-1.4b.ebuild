# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/battalion/battalion-1.4b.ebuild,v 1.13 2007/03/13 14:33:58 nyhm Exp $

inherit games

DESCRIPTION="Be a rampaging monster and destroy the city."
HOMEPAGE="http://evlweb.eecs.uic.edu/aej/AndyBattalion.html"
SRC_URI="http://evlweb.eecs.uic.edu/aej/BATTALION/${PN}${PV}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu"

S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Modify data paths
	sed -i \
		-e "s:SOUNDS/:${GAMES_DATADIR}/${PN}/SOUNDS/:" \
		-e "s:MUSIC/:${GAMES_DATADIR}/${PN}/MUSIC/:" \
		audio.c || die "sed audio.c failed"
	sed -i \
		-e "s:DATA/:${GAMES_DATADIR}/${PN}/DATA/:" \
		-e "s:/usr/tmp:${GAMES_STATEDIR}:" \
		battalion.c || die "sed battalion.c failed"
	sed -i \
		-e "s:TEXTURES/:${GAMES_DATADIR}/${PN}/TEXTURES/:" \
		graphics.c || die "sed graphics.c failed"

	# Modify Makefile and add CFLAGS
	sed -i \
		-e "s:-O2:${CFLAGS}:" \
		Makefile || die "sed Makefile failed"
	# Only .raw sound files are used on Linux. The .au files are not needed.
	rm -f {SOUNDS,MUSIC}/*.au
}

src_install() {
	dogamesbin battalion || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r DATA MUSIC SOUNDS TEXTURES || die "doins failed"
	dodoc README

	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}"/battalion_hiscore
	fperms 660 "${GAMES_STATEDIR}"/battalion_hiscore

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Sound and music are not enabled by default."
	elog "Use the S and M keys to enable them in-game, or start the game with"
	elog "the -s and -m switches: battalion -s -m"
}
