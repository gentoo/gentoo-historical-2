# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/psemu-eternalspu/psemu-eternalspu-1.41-r1.ebuild,v 1.3 2004/05/27 01:45:03 mr_bones_ Exp $

inherit games

DESCRIPTION="PSEmu Eternal SPU"
HOMEPAGE="http://www1.odn.ne.jp/psx-alternative/"
SRC_URI="http://www1.odn.ne.jp/psx-alternative/download/spuEternal${PV//.}_linux.tgz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="media-libs/libsdl"

S="${WORKDIR}"

src_install() {
	exeinto "${GAMES_LIBDIR}/psemu/plugins"
	doexe libspuEternal.so.*
	dodoc *.txt
	prepgamesdirs
}
