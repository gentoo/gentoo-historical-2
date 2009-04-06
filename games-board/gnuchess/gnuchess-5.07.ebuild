# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnuchess/gnuchess-5.07.ebuild,v 1.12 2009/04/06 17:30:41 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline )"

PATCHES=( "${FILESDIR}"/gnuchess-gcc4.patch )

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_with readline)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS TODO doc/README
	prepgamesdirs
}
