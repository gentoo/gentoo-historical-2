# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/bomberclone/bomberclone-0.11.1.ebuild,v 1.3 2004/02/08 05:41:52 vapier Exp $

inherit games

DESCRIPTION="BomberMan clone with network game support"
HOMEPAGE="http://www.bomberclone.de/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

RDEPEND="virtual/x11
	>=media-libs/libsdl-1.1.0
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_compile() {
	egamesconf --datadir="${GAMES_DATADIR_BASE}" || die
	sed -i \
		-e "/PACKAGE_DATA_DIR/ s:/usr/games/share/games/:${GAMES_DATADIR}/:" \
			config.h || die "sed config.h failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/${PN} || die "dogamesbin failed"

	dodir ${GAMES_DATADIR}/${PN}
	cp -R data/{gfx,maps,player,tileset}/ ${D}/${GAMES_DATADIR}/${PN} \
		|| die "cp failed"

	dodoc AUTHORS ChangeLog README TODO
	prepgamesdirs
}
