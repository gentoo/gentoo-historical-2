# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/sable/sable-1.0.ebuild,v 1.4 2007/04/21 10:39:15 nyhm Exp $

inherit eutils games

DESCRIPTION="A frantic 3D space shooter"
HOMEPAGE="http://www.stanford.edu/~mcmartin/sable/"
SRC_URI="http://www.stanford.edu/~mcmartin/${PN}/${P}-src.tgz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"

S=${WORKDIR}/${PN}

src_compile() {
	emake INSTALL_RESDIR="${GAMES_DATADIR}" || die "emake failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r models sfx textures || die "doins failed"
	dodoc ChangeLog README

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} Sable

	prepgamesdirs
}
