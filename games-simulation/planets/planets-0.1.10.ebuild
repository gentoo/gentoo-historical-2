# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/planets/planets-0.1.10.ebuild,v 1.9 2005/05/04 16:17:53 luckyduck Exp $

inherit games

DESCRIPTION="a simple interactive planetary system simulator"
SRC_URI="http://planets.homedns.org/dist/${P}.tgz"
HOMEPAGE="http://planets.homedns.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~amd64"
IUSE=""

RDEPEND="dev-lang/tcl
	dev-lang/tk"
DEPEND="${RDEPEND}
	dev-lang/ocaml"

src_compile() {
	make clean
	make planets || die "make failed"
}

src_install() {
	dogamesbin planets || die "dogamesbin failed"
	doman planets.1
	dodoc CREDITS CHANGES TODO KEYBINDINGS.txt README
	prepgamesdirs
}
