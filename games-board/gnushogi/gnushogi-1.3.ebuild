# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnushogi/gnushogi-1.3.ebuild,v 1.10 2005/06/15 18:29:48 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="Japanese version of chess (commandline + X-Version)"
HOMEPAGE="http://www.gnu.org/directory/games/gnushogi.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE="X"

RDEPEND="virtual/libc
	sys-libs/ncurses
	X? ( virtual/x11 )"
DEPEND="${RDEPEND}
	>=sys-devel/bison-1.34
	>=sys-devel/flex-2.5
	>=sys-apps/sed-4"

src_unpack() {
	local f

	unpack ${A}
	cd ${S}
	for f in `grep -Rl -- -ltermcap *` ; do
		einfo "Fixing ${f}"
		sed -i \
			-e 's:-ltermcap:-lcurses:' ${f} \
				|| die "sed ${f} failed"
	done
	epatch "${FILESDIR}/${PV}-errno.patch"
}

src_compile() {
	egamesconf \
		$(use_with X x) \
		$(use_with X xshogi) || die
	addpredict /usr/games/lib/gnushogi/gnushogi.hsh
	emake || die "emake failed"
}

src_install() {
	dogamesbin gnushogi/gnushogi      || die "dogamesbin failed"
	if use X ; then
		dogamesbin xshogi/xshogi      || die "dogamesbin failed (X)"
	fi
	dogameslib gnushogi/gnushogi.bbk  || die "dogameslib failed"
	dodoc README NEWS CONTRIB
	prepgamesdirs
}
