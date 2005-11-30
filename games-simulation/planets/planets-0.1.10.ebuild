# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/planets/planets-0.1.10.ebuild,v 1.1 2003/09/11 12:22:49 vapier Exp $

inherit games

DESCRIPTION="a simple interactive planetary system simulator"
SRC_URI="http://planets.homedns.org/dist/${P}.tgz"
HOMEPAGE="http://planets.homedns.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="dev-lang/tcl"
DEPEND="${RDEPEND}
	dev-lang/ocaml"

src_compile() {
	make clean
	make planets || die
}

src_install() {
	dogamesbin planets
	doman planets.1
	dodoc CREDITS CHANGES TODO KEYBINDINGS.txt README
	prepgamesdirs
}
