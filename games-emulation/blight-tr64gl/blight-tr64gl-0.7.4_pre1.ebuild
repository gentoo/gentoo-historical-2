# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/blight-tr64gl/blight-tr64gl-0.7.4_pre1.ebuild,v 1.5 2004/06/24 22:24:23 agriffis Exp $

inherit games

MY_P="blight_tr64gl-0.7.4-pre1"
DESCRIPTION="An OpenGL graphics plugin for the mupen64 N64 emulator"
HOMEPAGE="http://deltaanime.ath.cx/~blight/n64/"
SRC_URI="http://deltaanime.ath.cx/~blight/n64/blight_tr64gl_port/${MY_P}.so.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="media-libs/libsdl"

S="${WORKDIR}"

src_install () {
	exeinto "${GAMES_LIBDIR}/mupen64/plugins"
	doexe ${MY_P}.so || die "doexe failed"
	prepgamesdirs
}
