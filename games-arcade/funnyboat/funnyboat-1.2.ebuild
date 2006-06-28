# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/funnyboat/funnyboat-1.2.ebuild,v 1.2 2006/06/28 01:52:34 metalgod Exp $

inherit eutils games

DESCRIPTION="A side scrolling shooter game starring a steamboat on the sea"
HOMEPAGE="http://funnyboat.sourceforge.net/"
SRC_URI="mirror://sourceforge/funnyboat/${P}.tar.gz"

LICENSE="GPL-2 CCPL-Attribution-2.5 CCPL-Attribution-NonCommercial-NoDerivs-2.0"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="dev-python/pygame"

S=${WORKDIR}/${PN}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data *.py || die "doins failed"
	dodoc *.txt
	newicon data/kuvake.png "${PN}.png"
	games_make_wrapper ${PN} "python main.py" "${GAMES_DATADIR}"/${PN}
	make_desktop_entry "${PN}" "Trip on the Funny Boat"
	prepgamesdirs
}
