# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-server/halfd/halfd-2.19.ebuild,v 1.4 2004/06/24 23:18:27 agriffis Exp $

inherit games

DESCRIPTION="Half-Life server management tool"
HOMEPAGE="http://halfd.org/"
SRC_URI="http://halfd.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="dev-tcltk/tclx
	dev-lang/perl"

src_install() {
	local dir=${GAMES_PREFIX_OPT}/halflife
	dodir ${dir}
	dodoc FAQ.txt INSTALL* README UPGRADE
	rm FAQ.txt INSTALL* README UPGRADE
	cp -r * ${D}/${dir}/
	prepgamesdirs
}
