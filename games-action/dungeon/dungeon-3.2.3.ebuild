# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/dungeon/dungeon-3.2.3.ebuild,v 1.8 2005/03/04 04:20:24 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="A linux port of the Dungeon game once distributed by DECUS"
HOMEPAGE="http://www.ibiblio.org/linsearch/lsms/dungeon-3.2.3.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/games/textrpg/${P}.src.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="dev-lang/f2c"

S=${WORKDIR}/dungn32c
DATS=${GAMES_DATADIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	local f

	# f2c steps on itself
	for f in *.f
	do
		emake ${f/.f/.c} || die "emake failed"
	done
	sed -i \
		-re "s:d(indx|text).dat:${DATS}/&:g" \
		-e "s:ofnmlen = [^;]+:&+${#DATS}+1:g" \
		game.c || die "sed game.c failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin dungeon || die "dogamesbin failed"
	insinto "${DATS}"
	doins dindx.dat dtext.dat || die "doins failed"
	doman "${FILESDIR}/dungeon.6"
	dodoc README *.txt *.doc
	prepgamesdirs
}
