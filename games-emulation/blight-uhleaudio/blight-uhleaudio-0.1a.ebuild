# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/blight-uhleaudio/blight-uhleaudio-0.1a.ebuild,v 1.1 2003/09/09 16:26:49 vapier Exp $

inherit games

MY_P="uhleaudio-${PV}"
DESCRIPTION="An audio plugin for the mupen64 N64 emulator"
SRC_URI="http://deltaanime.ath.cx/~blight/n64/uhleaudio_plugin/${MY_P}.so"
HOMEPAGE="http://deltaanime.ath.cx/~blight/n64/"

KEYWORDS="x86"
LICENSE="as-is"
SLOT="0"
IUSE=""

RDEPEND="media-libs/libsdl"

src_unpack() {
	cp ${DISTDIR}/${A} ${WORKDIR} || die "cp failed"
}

src_install () {
	exeinto ${GAMES_LIBDIR}/mupen64/plugins
	doexe ${WORKDIR}/${MY_P}.so || die "doexe failed"
	prepgamesdirs
}
