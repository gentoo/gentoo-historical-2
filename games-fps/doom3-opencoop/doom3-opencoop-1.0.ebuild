# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-opencoop/doom3-opencoop-1.0.ebuild,v 1.1 2005/11/22 06:11:49 vapier Exp $

inherit games

DESCRIPTION="add coop support to Doom 3"
HOMEPAGE="http://www.d3opencoop.com/"
SRC_URI="opencoop1.0.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="nofetch"

DEPEND="games-fps/doom3"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please visit this website:"
	einfo "http://www.d3opencoop.com/index.php?section=files"
	einfo "And download ${A} into ${DISTDIR}"
}

src_install() {
	insinto "${GAMES_PREFIX_OPT}"/doom3
	doins -r opencoop || die "doins failed"
	prepgamesdirs
}
