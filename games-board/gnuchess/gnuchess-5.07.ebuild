# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnuchess/gnuchess-5.07.ebuild,v 1.4 2004/06/24 22:17:44 agriffis Exp $

inherit games

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

KEYWORDS="x86 ppc sparc alpha amd64"
LICENSE="GPL-2"
SLOT="0"
IUSE="readline"

DEPEND="virtual/glibc
	readline? ( sys-libs/readline )"

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		`use_with readline` \
			|| die
	emake || die "emake failed"
}
src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS TODO doc/README || die "dodoc failed"
	prepgamesdirs
}
