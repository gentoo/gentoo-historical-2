# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/gtkradiant/gtkradiant-1.4.0.ebuild,v 1.6 2004/05/01 20:08:42 wolf31o2 Exp $

inherit games eutils

DESCRIPTION="FPS level editor"
HOMEPAGE="http://www.qeradiant.com/?data=editors/gtk"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/qeradiant/GtkRadiant/GtkRadiant-1_4/Linux/linux-radiant-${PV}.run"

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
	virtual/x11
	virtual/opengl"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself
	check_license
}

src_install() {
	dodir ${dir}
	cp -r bin/Linux/x86/* ${Ddir}/
	chmod -R a+x ${Ddir}/
	cp -r README license.txt core/* ${Ddir}
	echo ${PV:2:1} > ${Ddir}/RADIANT_MAJOR
	echo ${PV:4} > ${Ddir}/RADIANT_MINOR

	dogamesbin ${FILESDIR}/{q3map2,radiant}
	insinto ${dir}/games
	doins ${FILESDIR}/*.game
	exeinto ${dir} || die "${dir}"
	doexe ${FILESDIR}/{q3map2,radiant}

	dodir ${GAMES_PREFIX_OPT}
	cp -r et ${D}/${GAMES_PREFIX_OPT}/enemy-territory
	cp -r q3 ${D}/${GAMES_PREFIX_OPT}/quake3
	cp -r wolf ${D}/${GAMES_PREFIX_OPT}/rtcw
	dodir ${GAMES_DATADIR}
	cp -r q2 ${D}/${GAMES_DATADIR}/quake2-data

	prepgamesdirs
}
