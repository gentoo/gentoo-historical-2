# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnuchess/gnuchess-5.07.ebuild,v 1.8 2005/12/20 04:46:26 hanno Exp $

inherit games

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

KEYWORDS="alpha amd64 ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline )"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/gnuchess-gcc4.patch
}

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_with readline) \
			|| die
	emake || die "emake failed"
}
src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS TODO doc/README
	prepgamesdirs
}
