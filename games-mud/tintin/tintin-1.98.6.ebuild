# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/tintin/tintin-1.98.6.ebuild,v 1.1 2008/10/23 22:55:57 mr_bones_ Exp $

inherit games

DESCRIPTION="(T)he k(I)cki(N) (T)ickin d(I)kumud clie(N)t"
HOMEPAGE="http://tintin.sourceforge.net/"
SRC_URI="mirror://sourceforge/tintin/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="sys-libs/zlib
	sys-libs/readline
	sys-libs/ncurses"

S=${WORKDIR}/tt/src

src_unpack() {
	unpack ${A}
	sed -i \
		-e '/^CC/d' \
		-e '/^MAKE/d' \
		-e '/^CFLAGS/s/=/+=/' "${S}/Makefile.in" \
		|| die "sed failed"
}

src_install () {
	dogamesbin tt++ || die "dogamesbin failed"
	dodoc ../{CREDITS,FAQ,README,SCRIPTS,TODO,docs/*}
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "**** OLD TINTIN SCRIPTS ARE NOT 100% COMPATIBLE WITH THIS VERSION ****"
	ewarn "read the README for more details."
	echo
}
