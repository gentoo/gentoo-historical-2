# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/simutrans/simutrans-0.82.10.ebuild,v 1.2 2003/09/18 19:20:18 msterret Exp $

inherit games

MY_PV=${PV//./_}
DESCRIPTION="A free Transport Tycoon clone"
HOMEPAGE="http://www.simutrans.de/"
# 0_82_10 was a bugfix release and it uses the 0_82_9 base file.
SRC_URI="http://www.simugraph.com/simutrans/data/simubase-0_82_9exp.zip
	http://www.simugraph.com/simutrans/data/simulinux-${MY_PV}exp.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86"

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl"

S=${WORKDIR}/${PN}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir ${dir}

	mv * ${D}/${dir}/

	dogamesbin ${FILESDIR}/simutrans
	dosed "s:GENTOO_DIR:${dir}:" ${GAMES_BINDIR}/simutrans

	prepgamesdirs
}
