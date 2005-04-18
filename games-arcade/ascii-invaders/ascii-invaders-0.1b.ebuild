# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/ascii-invaders/ascii-invaders-0.1b.ebuild,v 1.13 2005/04/18 16:47:27 nigoro Exp $

inherit games

DESCRIPTION="Space invaders clone, using ncurses library"
HOMEPAGE="http://www.ip9.org/munro/invaders/"
SRC_URI="http://www.ip9.org/munro/invaders/invaders${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha sparc ~amd64 ppc ppc64"
IUSE=""

DEPEND="sys-libs/ncurses"

S="${WORKDIR}/invaders"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's/-lcurses/-lncurses/g' Makefile \
		|| die "sed Makefile failed"
}

src_install() {
	dogamesbin ascii_invaders || die "dogamesbin failed"
	dodoc TODO
	prepgamesdirs
}
