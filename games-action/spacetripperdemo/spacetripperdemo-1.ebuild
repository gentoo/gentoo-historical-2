# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/spacetripperdemo/spacetripperdemo-1.ebuild,v 1.3 2004/04/19 20:53:27 wolf31o2 Exp $

inherit games eutils

DESCRIPTION="hardcore arcade shoot-em-up"
HOMEPAGE="http://www.pompom.org.uk/"
SRC_URI="http://www.btinternet.com/%7Ebongpig/${PN}.sh"

LICENSE="POMPOM"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	check_license
	unpack_makeself
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir ${dir} ${GAMES_BINDIR}

	cp -r preview run styles ${D}/${dir}/

	exeinto ${dir}
	doexe bin/x86/*
	dosed "s:XYZZY:${dir}:" ${dir}/${PN}
	dosym ${dir}/${PN} ${GAMES_BINDIR}/${PN}

	insinto ${dir}
	doins README license.txt icon.xpm

	prepgamesdirs
}
