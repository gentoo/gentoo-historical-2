# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/hexxagon/hexxagon-0.3.2.ebuild,v 1.1 2004/02/23 23:54:29 mr_bones_ Exp $

inherit games

DESCRIPTION="clone of the original DOS game"
SRC_URI="http://nesqi.homeip.net/hexxagon/download/${P}.tar.gz"
HOMEPAGE="http://nesqi.homeip.net/hexxagon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="readline gtk"

DEPEND="|| (
		readline? ( sys-libs/readline )
		gtk? ( =x11-libs/gtk+-1* )
		sys-libs/readline
	)"

src_compile() {
	egamesconf || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc README
	prepgamesdirs
}
