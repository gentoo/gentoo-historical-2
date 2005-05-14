# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom-data/doom-data-1.ebuild,v 1.8 2005/05/14 02:04:34 agriffis Exp $

inherit games

DESCRIPTION="collection of doom wad files from id"
HOMEPAGE="http://www.idsoftware.com/"
SRC_URI="mirror://gentoo/doom1.wad.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="!games-fps/freedoom"

S=${WORKDIR}

src_install() {
	insinto ${GAMES_DATADIR}/doom-data
	doins *.wad || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "When playing doom games, just put your"
	einfo "retail wad files into ${GAMES_DATADIR}/doom-data"
}
