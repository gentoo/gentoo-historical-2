# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-ra3/quake3-ra3-1.7.ebuild,v 1.5 2004/06/24 22:45:17 agriffis Exp $

MOD_DESC="Rocket Arena 3"
MOD_NAME=arena
MOD_BINS=ra3
inherit games games-q3mod

SRC_URI="ra317cl.zip
	ra317sv.zip"
HOMEPAGE="http://www.planetquake.com/servers/arena/"

LICENSE="Q3AEULA"
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Download the following files from FilePlanet and put them in"
	einfo "${DISTDIR}"
	einfo
	for f in ${A} ; do
		einfo "http://www.fileplanet.com/dl.aspx?servers/arena/${f}"
	done
}
