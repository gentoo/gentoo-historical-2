# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-cdoom/doom3-cdoom-1.3.1.ebuild,v 1.1 2009/07/24 18:24:42 nyhm Exp $

MOD_DESC="Doom 1 conversion for Doom 3"
MOD_NAME="Classic Doom"
MOD_DIR="cdoom"
MOD_ICON="cdoom.ico"

inherit games games-mods

HOMEPAGE="http://cdoom.d3files.com/"
SRC_URI="classic_doom_3_${PV//.}.zip"

LICENSE="as-is"
RESTRICT="fetch"

RDEPEND=">=games-fps/doom3-1.3.1304"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.filefront.com/8748743"
	elog "and move it to ${DISTDIR}"
}

src_unpack() {
	games-mods_src_unpack

	cd "${MOD_DIR}" || die
	rm -f *.{bat,url} cdoom_{dll,mac}.pk4 || die
}
