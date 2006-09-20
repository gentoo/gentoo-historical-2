# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/abe/abe-1.1.ebuild,v 1.2 2006/09/20 16:47:12 blubb Exp $

inherit eutils games

DESCRIPTION="A scrolling, platform-jumping, key-collecting, ancient pyramid exploring game"
HOMEPAGE="http://abe.sourceforge.net"
SRC_URI="mirror://sourceforge/abe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.3
	>=media-libs/sdl-mixer-1.2.5"

src_unpack() {
	unpack ${A}
	sed -i \
		-e "/^TR_CFLAGS/d" \
		-e "/^TR_CXXFLAGS/d" \
		"${S}"/configure.in \
		|| die "sed failed"
}

src_compile() {
	./autogen.sh || die "autogen.sh failed"
	egamesconf --with-data-dir="${GAMES_DATADIR}/${PN}" || die
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/abe || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r images sounds maps || die "doins failed"
	dodoc AUTHORS ChangeLog README
	prepgamesdirs
}
