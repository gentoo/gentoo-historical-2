# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-urbanterror/quake3-urbanterror-3.4.ebuild,v 1.5 2004/06/24 22:46:01 agriffis Exp $

MOD_DESC="total transformation realism based MOD"
MOD_NAME=q3ut3
MOD_BINS=ut3
inherit games games-q3mod

HOMEPAGE="http://www.urbanterror.net/"
SRC_URI="urbanterror3.zip
	UrbanTerror31.zip
	UrbanTerror32.zip
	UrbanTerror33.zip
	UrbanTerror34.zip"

LICENSE="freedist"
SLOT="3"
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please goto ${HOMEPAGE}"
	einfo "and download ${A} into ${DISTDIR}"
}

src_unpack() {
	unpack urbanterror3.zip
	cd q3ut3
	unpack UrbanTerror31.zip
	unpack UrbanTerror32.zip
	unpack UrbanTerror33.zip
	unpack UrbanTerror34.zip
}
