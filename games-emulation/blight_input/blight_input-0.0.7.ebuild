# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/blight_input/blight_input-0.0.7.ebuild,v 1.5 2004/09/23 08:50:50 mr_bones_ Exp $

inherit games

DESCRIPTION="An input plugin for the mupen64 N64 emulator"
SRC_URI="http://deltaanime.ath.cx/~blight/n64/blight_input_plugin/${P}.tgz"
HOMEPAGE="http://mupen64.emulation64.com/"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 -ppc -sparc"
SLOT="0"

DEPEND=">=media-libs/libsdl-1.2.4
	media-libs/freetype"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Death to all who distribute their stinking config.cache files!
	rm -f config.cache
}

src_install() {
	make install || die "make install failed"
	exeinto "${GAMES_LIBDIR}/mupen64/plugins"
	doexe src/blight_input.so || die "doexe failed"
	dodoc AUTHORS ChangeLog README ToDo
	prepgamesdirs
}
