# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/marbleblastdemo/marbleblastdemo-1.3.ebuild,v 1.2 2004/02/20 06:20:00 mr_bones_ Exp $

inherit games eutils

DESCRIPTION="race marbles through crazy stages"
HOMEPAGE="http://garagegames.com/pg/product/view.php?id=3"
SRC_URI="ftp://ggdev-1.homelan.com/marbleblast/MarbleBlastDemo-${PV}.sh.bin"

LICENSE="MARBLEBLAST"
SLOT="0"
KEYWORDS="-* x86"

DEPEND=""

S=${WORKDIR}

pkg_setup() {
	check_license
	games_pkg_setup
}

src_unpack() {
	unpack_makeself
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	dodir ${dir} ${GAMES_BINDIR}

	tar -zxf MarbleBlast.tar.gz -C ${D}/${dir} || die "extracting MarbleBlast.tar.gz"

	exeinto ${dir}
	doexe bin/Linux/x86/marbleblastdemo
	dosym ${dir}/marbleblastdemo ${GAMES_BINDIR}/marbleblastdemo

	dodoc README_DEMO.txt

	prepgamesdirs
}
