# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/pydance-songs/pydance-songs-20030926.ebuild,v 1.1 2003/09/26 20:01:20 vapier Exp $

inherit games

DESCRIPTION="Music for the pyDDR game"
HOMEPAGE="http://icculus.org/pyddr/"
SRC_URI="http://icculus.org/pyddr/6jan.ogg
	http://icculus.org/pyddr/6jan.dance
	http://icculus.org/pyddr/6jan-banner.png

	http://icculus.org/pyddr/0forkbomb.ogg
	http://icculus.org/pyddr/0forkbomb.step

	http://icculus.org/pyddr/synrg.ogg
	http://icculus.org/pyddr/synrg.dance
	http://icculus.org/pyddr/synrg-bg.png"

LICENSE="X11"
SLOT="0"
KEYWORDS="x86"

RDEPEND="games-arcade/pydance"

S=${WORKDIR}

src_unpack() { :;}

src_install() {
	insinto ${GAMES_DATADIR}/pydance/songs
	cd ${DISTDIR}
	doins ${A} || die
}
