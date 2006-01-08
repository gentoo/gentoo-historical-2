# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-alienswarm/ut2004-alienswarm-1.3.ebuild,v 1.3 2006/01/08 01:12:41 mr_bones_ Exp $

MOD_DESC="Alien Swarm is an overhead view tactical squad-based shooter"
MOD_NAME="Alien Swarm"
MOD_BINS=alienswarm
MOD_TBZ2="alienswarm alien.swarm_phalanx.campaign alien.swarm_telic.campaign"
MOD_ICON=alienswarm.xpm
inherit games games-ut2k4mod

HOMEPAGE="http://www.blackcatgames.com/swarm/"
SRC_URI="alien.swarm_${PV}-english.run
	alien.swarm_phalanx.campaign-addon.run
	alien.swarm_telic.campaign-addon.run"

LICENSE="freedist"
IUSE=""

src_install() {
	games-ut2k4mod_src_install
	exeinto "${GAMES_PREFIX_OPT}"/ut2004
	doexe "${S}"/bin/* || die
	prepgamesdirs
}
