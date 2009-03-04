# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/bomberclone/bomberclone-0.11.8.ebuild,v 1.7 2009/03/04 04:20:09 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="BomberMan clone with network game support"
HOMEPAGE="http://www.bomberclone.de/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86"
IUSE="X"

DEPEND=">=media-libs/libsdl-1.1.0
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mikmod]
	X? ( x11-libs/libXt )"

src_prepare() {
	ecvs_clean
	# bug #260894
	sed -i \
		-e 's/ -Werror//' \
		configure \
		|| die "sed failed"
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_with X x) \
		--datadir="${GAMES_DATADIR_BASE}" || die
	sed -i \
		-e "/PACKAGE_DATA_DIR/ s:/usr/games/share/games/:${GAMES_DATADIR}/:" \
		config.h \
		|| die "sed config.h failed"
}

src_install() {
	dogamesbin src/${PN} || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/{gfx,maps,player,tileset,music} || die "doins failed"
	find "${D}" -name "Makefile*" -exec rm -f '{}' +

	dodoc AUTHORS ChangeLog README TODO
	doicon data/pixmaps/bomberclone.png
	make_desktop_entry bomberclone Bomberclone
	prepgamesdirs
}
