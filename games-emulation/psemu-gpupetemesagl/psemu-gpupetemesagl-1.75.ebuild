# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/psemu-gpupetemesagl/psemu-gpupetemesagl-1.75.ebuild,v 1.4 2004/06/24 22:34:13 agriffis Exp $

inherit games

DESCRIPTION="PSEmu MesaGL GPU"
HOMEPAGE="http://home.t-online.de/home/PeteBernert/"
SRC_URI="http://home.t-online.de/home/PeteBernert/gpupetemesagl${PV//.}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/opengl"

S="${WORKDIR}"

src_install() {
	exeinto "${GAMES_LIBDIR}/psemu/plugins"
	doexe lib*
	exeinto "${GAMES_LIBDIR}/psemu/cfg"
	doexe cfgPeteMesaGL
	insinto "${GAMES_LIBDIR}/psemu/cfg"
	doins gpuPeteMesaGL.cfg
	dodoc readme.txt version.txt
	prepgamesdirs
}
