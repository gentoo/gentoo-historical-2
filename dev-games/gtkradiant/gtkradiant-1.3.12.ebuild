# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/gtkradiant/gtkradiant-1.3.12.ebuild,v 1.8 2006/03/15 22:38:47 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="FPS level editor"
HOMEPAGE="http://www.qeradiant.com/?data=editors/gtk"
SRC_URI="mirror://idsoftware/qeradiant/GtkRadiant/GtkRadiant-1_3/Linux/linux-radiant-${PV}.run"

LICENSE="qeradiant"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""

RDEPEND="media-libs/libpng
	sys-libs/zlib
	=dev-libs/glib-2*
	=x11-libs/gtk+-2*
	dev-libs/atk
	x11-libs/pango
	x11-libs/gtkglext
	dev-libs/libxml2
	virtual/opengl"

S=${WORKDIR}

src_unpack() {
	unpack_makeself
	check_license
}

src_install() {
	local dir=/opt/${PN}
	dodir ${dir}
	cp -r bin/Linux/x86/* ${D}/${dir}/
	chmod -R a+x ${D}/${dir}/
	cp -r README license.txt core/* ${D}/${dir}/
	echo ${PV:2:1} > ${D}/${dir}/RADIANT_MAJOR
	echo ${PV:4} > ${D}/${dir}/RADIANT_MINOR

	dobin ${FILESDIR}/{q3map2,radiant}
	insinto ${dir}/games
	doins ${FILESDIR}/*.game

	dodir ${GAMES_PREFIX_OPT}
	cp -r et ${D}/${GAMES_PREFIX_OPT}/enemy-territory
	cp -r q3 ${D}/${GAMES_PREFIX_OPT}/quake3
	cp -r wolf ${D}/${GAMES_PREFIX_OPT}/rtcw
	dodir ${GAMES_DATADIR}
	cp -r q2 ${D}/${GAMES_DATADIR}/quake2-data
}
