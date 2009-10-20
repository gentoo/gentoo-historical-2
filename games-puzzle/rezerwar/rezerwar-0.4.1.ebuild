# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/rezerwar/rezerwar-0.4.1.ebuild,v 1.1 2009/10/20 21:57:43 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Puzzle game like the known tetromino and the average pipe games"
HOMEPAGE="http://tamentis.com/projects/rezerwar/"
SRC_URI="http://tamentis.com/projects/rezerwar/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libsdl[audio,joystick,video]
	media-libs/sdl-mixer[vorbis]"

src_prepare() {
	sed -i \
		-e '/check_sdl$/d' \
		configure \
		|| die 'sed failed'
}

src_configure() {
	SDLCONFIG=sdl-config \
	TARGET_BIN="${GAMES_BINDIR}" \
	TARGET_DOC=/usr/share/doc/${PF} \
	TARGET_DATA="${GAMES_DATADIR}/${PN}" \
	MK_EXTRACFLAGS="${CFLAGS}" \
	./configure \
	|| die "configure failed"
	sed -i \
		-e '/TARGET_DOC/d' \
		Makefile \
		|| die "sed failed"
}

src_install() {
	dodir "${GAMES_BINDIR}"
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc doc/{CHANGES,README,TODO}
	make_desktop_entry rezerwar Rezerwar
	prepgamesdirs
}
