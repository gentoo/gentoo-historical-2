# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/queen/queen-0.ebuild,v 1.8 2006/08/16 09:14:27 blubb Exp $

inherit games

DESCRIPTION="Flight of the Amazon Queen is a 2D point-and-click adventure game set in the 1940s"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/scummvm/FOTAQ_Talkie.zip"

LICENSE="queen"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND=">=games-engines/scummvm-0.6.0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/FOTAQ_Talkie"

src_install() {
	games_make_wrapper queen "scummvm -f -p \"${GAMES_DATADIR}/${PN}\" queen" .
	insinto "${GAMES_DATADIR}/${PN}"
	doins queen.1c || die "doins failed"
	dodoc readme.txt
	prepgamesdirs
}
