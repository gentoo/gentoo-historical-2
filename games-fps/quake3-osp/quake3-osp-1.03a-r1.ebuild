# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-osp/quake3-osp-1.03a-r1.ebuild,v 1.1 2006/10/27 16:06:54 wolf31o2 Exp $

MOD_DESC="a touirnament-based mod"
MOD_NAME="OSP"
MOD_DIR="osp"

inherit games games-mods

SRC_URI="http://www.flatlands.ch/filebase/mods/left/osp-Quake3-${PV}_full.zip
	http://games13.xs4all.nl/quake3/osp-Quake3-${PV}_full.zip"
HOMEPAGE="http://www.orangesmoothie.org/"

LICENSE="GPL-2"

KEYWORDS="-* ~amd64 ~ppc ~x86"

RDEPEND="ppc? ( games-fps/${GAME} )
	!ppc? (
		|| (
			games-fps/${GAME}
			games-fps/${GAME}-bin ) )"

pkg_nofetch() {
	einfo "Go to http://www.fileshack.com/file.x?fid=1515 and download"
	einfo "${A} and put it in ${DISTDIR}"
}
