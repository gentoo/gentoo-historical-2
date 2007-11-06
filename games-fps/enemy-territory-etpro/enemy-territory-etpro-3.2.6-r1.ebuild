# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/enemy-territory-etpro/enemy-territory-etpro-3.2.6-r1.ebuild,v 1.2 2007/11/06 21:07:32 wolf31o2 Exp $

MOD_DESC="a series of minor additions to Enemy Territory to make it more fun"
MOD_NAME="ETPro"
#MOD_TBZ2
#MOD_ICON
MOD_DIR="etpro"
GAME="enemy-territory"

inherit games games-mods

HOMEPAGE="http://bani.anime.net/etpro/"
SRC_URI="http://etpro.anime.net/etpro-${PV//./_}.zip"

LICENSE="as-is"

RDEPEND="games-fps/${GAME}"
