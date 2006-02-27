# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/angband/angband-3.0.6.ebuild,v 1.1 2006/02/27 21:31:21 tupone Exp $

inherit flag-o-matic games

DESCRIPTION="A roguelike dungeon exploration game based on the books of J.R.R.Tolkien"
HOMEPAGE="http://thangorodrim.net/"
SRC_URI="ftp://ftp.thangorodrim.net/pub/${PN}/Source/${P}.tar.gz"

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~sparc ~x86"
IUSE="X gtk"

DEPEND=">=sys-libs/ncurses-5
	gtk? (
		=x11-libs/gtk+-1.2*
	)
	X? ( || ( x11-libs/libXaw virtual/x11 ) )"

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		--bindir="${GAMES_BINDIR}" \
		--with-setgid="${GAMES_GROUP}" \
		$(use_enable gtk) \
		$(use_with X x) \
		|| die "egamesconf failed"
	append-ldflags -Wl,-z,now
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog THANKS TODO changes.txt compile.txt readme.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	chmod -R g+w "${ROOT}${GAMES_DATADIR}"/angband/lib/{apex,save,user}
}
