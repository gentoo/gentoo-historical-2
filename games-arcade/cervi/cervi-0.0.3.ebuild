# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/cervi/cervi-0.0.3.ebuild,v 1.5 2004/12/21 13:30:56 josejx Exp $

inherit games

S="${WORKDIR}/${PN}"
DESCRIPTION="A multiplayer game where players drive a worm and try not to collide with anything"
SRC_URI="http://tomi.nomi.cz/download/${P}.tar.bz2"
HOMEPAGE="http://tomi.nomi.cz/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

RDEPEND="x11-libs/gtk+
	media-sound/esound
	media-sound/timidity++"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	sed -i \
		-e "/^CFLAGS/ s:-Wall:${CFLAGS}:" \
		-e "/^CXXFLAGS/ s:-Wall:${CXXFLAGS}:" ${S}/Makefile || \
			die "sed Makefile failed"
}

src_compile() {
	emake \
		prefix="/usr" \
		bindir="${GAMES_BINDIR}" \
		datadir="${GAMES_DATADIR}/${PN}" || \
			die "emake failed"
}

src_install() {
	dodir ${GAMES_BINDIR} || die "dodir failed"
	make \
		prefix=${D}/usr \
		bindir="${D}${GAMES_BINDIR}" \
		datadir="${D}${GAMES_DATADIR}/${PN}" install || \
			die "make install failed"
	dodoc AUTHORS COPYRIGHT README changelog || die "dodoc failed"
	prepgamesdirs
}
