# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/stoned-bin/stoned-bin-1.0.4.ebuild,v 1.2 2005/02/11 21:25:43 wolf31o2 Exp $

inherit games

DESCRIPTION="3D curling simulation"
HOMEPAGE="http://stoned.cute-ninjas.com/"
SRC_URI="http://stoned.cute-ninjas.com/download/${P/-bin}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="nostrip"

RDEPEND="virtual/opengl
	virtual/glut
	media-libs/sdl-net"

S="${WORKDIR}/${P/-bin}"

src_install() {
	into "${GAMES_PREFIX_OPT}"
	dobin stoned || die "dobin failed"
	dodoc README
	prepgamesdirs
}
