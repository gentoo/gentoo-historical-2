# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/stoned/stoned-1.1.5.ebuild,v 1.4 2004/06/24 23:23:56 agriffis Exp $

inherit games

DESCRIPTION="3D curling simulation"
HOMEPAGE="http://stoned.cute-ninjas.com/"
SRC_URI="http://stoned.cute-ninjas.com/download/${P}-i386-linux.tar.gz"

KEYWORDS="-* x86"
LICENSE="as-is"
SLOT="0"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glut
	media-libs/sdl-net
	media-libs/fmod
	sys-libs/zlib
	media-libs/libpng"

src_install() {
	into "${GAMES_PREFIX_OPT}"
	dobin stoned     || die "dobin failed"
	dodoc FAQ README || die "dodoc failed"
	prepgamesdirs
}
