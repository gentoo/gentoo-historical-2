# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/primateplunge/primateplunge-1.1.ebuild,v 1.7 2007/04/24 14:55:57 drizzt Exp $

inherit games

DESCRIPTION="Help poor Monkey navigate his way down through trecherous areas"
HOMEPAGE="http://www.aelius.com/primateplunge"
SRC_URI="http://www.ecs.soton.ac.uk/~njh/primateplunge/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TIPS
	prepgamesdirs
}
