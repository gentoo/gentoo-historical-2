# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/sirius/sirius-0.7.0.ebuild,v 1.1 2003/09/10 17:46:27 vapier Exp $

inherit games

DESCRIPTION="A program for playing the game of othello"
HOMEPAGE="http://sirius.bitvis.nu/"
SRC_URI="http://sirius.bitvis.nu/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="=x11-libs/gtk+-2*"

src_install() {
	egamesinstall
	dodoc BUGS README ChangeLog || die "dodoc failed"
	prepgamesdirs
}
