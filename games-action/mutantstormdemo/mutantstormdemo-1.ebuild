# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/mutantstormdemo/mutantstormdemo-1.ebuild,v 1.1 2003/09/10 19:29:16 vapier Exp $

inherit games eutils

DESCRIPTION="shoot through crazy psychedelic 3D environments"
HOMEPAGE="http://www.pompom.org.uk/"
SRC_URI="http://www.btinternet.com/%7Ebongpig/${PN}.sh"

LICENSE="POMPOM"
SLOT="0"
KEYWORDS="-* x86"

S=${WORKDIR}

src_unpack() {
	unpack_makeself
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir ${dir} ${GAMES_BINDIR}

	cp -r menu script styles ${D}/${dir}/

	exeinto ${dir}
	doexe bin/x86/*
	dosed "s:XYZZY:${dir}:" ${dir}/${PN}
	dosym ${dir}/${PN} ${GAMES_BINDIR}/${PN}

	insinto ${dir}
	doins pompom README buy_me icon.xpm instructions.htm license.txt

	prepgamesdirs
}
