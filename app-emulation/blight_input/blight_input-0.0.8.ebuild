# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/blight_input/blight_input-0.0.8.ebuild,v 1.1 2003/09/02 10:22:24 msterret Exp $

inherit games

S=${WORKDIR}
DESCRIPTION="An input plugin for the mupen64 N64 emulator"
SRC_URI="http://deltaanime.ath.cx/~blight/n64/blight_input_plugin/${P}.tar.gz"
HOMEPAGE="http://mupen64.emulation64.com/"

KEYWORDS="-* x86"
LICENSE="GPL-2"
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
	make install						|| die "make install failed"
	exeinto ${GAMES_LIBDIR}/mupen64/plugins
	doexe src/blight_input.so			|| die "doexe failed"
	dodoc AUTHORS ChangeLog README ToDo || die "dodoc failed"
}
