# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2003-bonuspack-de/ut2003-bonuspack-de-1.ebuild,v 1.3 2004/06/26 17:31:49 wolf31o2 Exp $

inherit games

MY_P="debonus.ut2mod.zip"
DESCRIPTION="Digital Extremes Bonus Pack for UT2003"
HOMEPAGE="http://www.unrealtournament2003.com/"
SRC_URI="mirror://3dgamers/pub/3dgamers5/games/unrealtourn2/Missions/${MY_P}
	mirror://3dgamers/pub/3dgamers/games/unrealtourn2/Missions/${MY_P}
	http://www.unixforces.net/downloads/${MY_P}"

LICENSE="ut2003"
SLOT="1"
KEYWORDS="x86"
RESTRICT="nostrip nomirror"

DEPEND="app-arch/unzip"
RDEPEND="games-fps/ut2003"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/ut2003
Ddir=${D}/${dir}

src_unpack() {
	unzip ${DISTDIR}/${A} || die "unpacking"
}

src_install() {
	mkdir -p ${Ddir}/System ${Ddir}/Maps ${Ddir}/StaticMeshes ${Ddir}/Textures \
		${Ddir}/Music ${Ddir}/Help
	games_umod_unpack DEBonus.ut2mod
	prepgamesdirs
}
