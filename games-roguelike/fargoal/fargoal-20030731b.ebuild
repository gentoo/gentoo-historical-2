# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/fargoal/fargoal-20030731b.ebuild,v 1.3 2004/06/24 23:12:39 agriffis Exp $

inherit eutils games

S="${WORKDIR}/${PN}"
DESCRIPTION="The Sword of Fargoal - a remake of C64's old dungeon crawler game"
HOMEPAGE="http://squidfighter.sourceforge.net/fargoal/"
SRC_URI="mirror://sourceforge/squidfighter/${PN}${PV}.zip"

KEYWORDS="x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-libs/allegro"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}/src
	epatch "${FILESDIR}/gentoo-home-write.patch"
	sed -i \
		-e "s/^\(C\(XX\)\?FLAGS =\).*/\1 ${CFLAGS} /g" Makefile \
			|| die "sed Makefile failed"
	sed -i \
		-e "s:sfx/:/${GAMES_DATADIR}/${PN}/sfx/:g" \
		-e "s:gfx/:/${GAMES_DATADIR}/${PN}/gfx/:g" \
		-e "s:data/:${GAMES_DATADIR}/${PN}/data/:g" {*,../data/sof.cfg} \
			|| die "sed failed"
}

src_compile() {
	cd src
	emake || die "emake failed"
}

src_install() {
	# install as fargoal instead of sword since that may conflict with
	# other packages.
	newgamesbin sword fargoal      || die "newgamesbin failed"
	dodir "${GAMES_DATADIR}/${PN}" || die "dodir failed"
	cp -r {data,gfx,sfx} ${D}/${GAMES_DATADIR}/${PN} \
		|| die "cp failed"
	dohtml readme.html             || die "dohtml failed"
	prepgamesdirs
}
