# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/wolfgl/wolfgl-0.93.ebuild,v 1.1 2003/09/09 18:10:15 vapier Exp $

#ECVS_SERVER="cvs.sourceforge.net:/cvsroot/wolfgl"
#ECVS_MODULE="wolfgl"
#inherit cvs
inherit games

DESCRIPTION="Wolfenstein and Spear of Destiny port using OpenGL"
HOMEPAGE="http://wolfgl.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tbz2
	mirror://sourceforge/wolfgl/wolfdata.zip
	mirror://sourceforge/wolfgl/sdmdata.zip"
#	mirror://sourceforge/wolfgl/wolfglx-wl6-${PV}.zip
#	mirror://sourceforge/wolfgl/wolfglx-sod-${PV}.zip

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/opengl
	virtual/x11"

src_compile() {
	make CFLAGS="${CFLAGS}" DATADIR=${GAMES_DATADIR}/${PN} || die
}

src_install() {
	newgamesbin linux/SDM/wolfgl wolfgl-sdm
	newgamesbin linux/SOD/wolfgl wolfgl-sod
	newgamesbin linux/WL1/wolfgl wolfgl-wl1
	newgamesbin linux/WL6/wolfgl wolfgl-wl6
	insinto ${GAMES_DATADIR}/${PN}
	doins ${WORKDIR}/*.{sdm,wl1}
	prepgamesdirs
}

pkg_postinst() {
	einfo "This installed the shareware data files for"
	einfo "Wolfenstein 3D and Spear Of Destiny."
	einfo "If you wish to play the full versions just"
	einfo "copy the data files to ${GAMES_DATADIR}/${PN}/"
	games_pkg_postinst
}
