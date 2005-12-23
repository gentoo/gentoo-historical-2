# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/tint/tint-0.03a.ebuild,v 1.6 2005/12/23 11:07:41 nigoro Exp $

inherit eutils games

MY_P=${P/-/_}
DESCRIPTION="Tint Is Not Tetris, a ncurses based clone of the original Tetris(tm) game"
HOMEPAGE="http://oasis.frogfoot.net/code/tint/"
SRC_URI="http://oasis.frogfoot.net/code/tint/download/$PV/$MY_P.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.4-r1"

src_unpack() {
	unpack $A
	cd "${S}"
	epatch "${FILESDIR}/${PV}-warnings.patch"
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		localstatedir="${GAMES_STATEDIR}" \
		|| die "emake failed"
}

src_install() {
	dogamesbin tint || die "dogamesbin failed"
	doman tint.6
	dodoc CREDITS NOTES
	insopts -m 0664
	insinto "${GAMES_STATEDIR}"
	doins tint.scores || die "doins failed"
	prepgamesdirs
}
