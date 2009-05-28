# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnuchess/gnuchess-5.07.ebuild,v 1.14 2009/05/28 09:22:39 tupone Exp $

EAPI=2
inherit flag-o-matic eutils games

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/gnuchess-gcc4.patch
	"${FILESDIR}"/gnuchess-glibc210.patch )

src_configure() {
	strip-flags # bug #199097
	egamesconf \
		--disable-dependency-tracking \
		$(use_with readline)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS TODO doc/README
	prepgamesdirs
}
