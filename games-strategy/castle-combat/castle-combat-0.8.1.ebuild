# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/castle-combat/castle-combat-0.8.1.ebuild,v 1.4 2007/09/15 21:24:09 tupone Exp $

inherit eutils games

DESCRIPTION="A clone of the old arcade game Rampart"
HOMEPAGE="http://www.linux-games.com/castle-combat/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-python/twisted
	dev-python/pygame"

pkg_setup() {
	games_pkg_setup
	if ! built_with_use media-libs/sdl-mixer mikmod; then
		die "Please emerge media-libs/sdl-mixer with USE=mikmod"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:src:$(games_get_libdir)/${PN}:" ${PN}.py \
		|| die "sed ${PN}.py failed"
	sed -i "/data_path =/s:\"data:\"${GAMES_DATADIR}/${PN}:" src/common.py \
		|| die "sed common.py failed"
}

src_install() {
	newgamesbin ${PN}.py ${PN} || die "newgamesbin failed"
	insinto "$(games_get_libdir)"/${PN}
	doins src/* || die "doins src failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/{colourba.ttf,gfx,sound} || die "doins data failed"
	newicon data/gfx/castle.png ${PN}.png
	make_desktop_entry ${PN} Castle-Combat
	dohtml data/font_read_me.html data/doc/rules.html
	dodoc TODO
	prepgamesdirs
}
