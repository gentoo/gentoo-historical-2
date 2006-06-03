# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/neverball/neverball-1.4.0.ebuild,v 1.3 2006/06/03 04:13:44 mr_bones_ Exp $

inherit games

DESCRIPTION="Clone of Super Monkey Ball using SDL/OpenGL"
HOMEPAGE="http://icculus.org/neverball/"
SRC_URI="http://icculus.org/neverball/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2.5
	>=media-libs/sdl-image-1.2.2
	media-libs/sdl-ttf
	virtual/opengl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/CONFIG_DATA/s:"\./data":"'${GAMES_DATADIR}/${PN}'":g' \
		share/config.h \
		|| die "sed config.h failed"
	sed -i \
		-e 's:-O3:$(E_CFLAGS):' \
		-e "/^MAPC_TARG/s/mapc/${PN}-mapc/" \
		Makefile \
		|| die "sed Makefile failed"
	find data/ -type f -exec chmod a-x \{\} \;
}

src_compile() {
	emake E_CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dogamesbin ${PN}-mapc neverball neverputt || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/* || die "doins failed"
	dodoc CHANGES README

	doicon icon/*.png
	make_desktop_entry neverball Neverball neverball.png
	make_desktop_entry neverputt Neverputt neverputt.png

	prepgamesdirs
}
