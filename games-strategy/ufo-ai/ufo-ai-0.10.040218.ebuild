# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/ufo-ai/ufo-ai-0.10.040218.ebuild,v 1.1 2004/03/11 02:26:22 wolf31o2 Exp $

inherit games

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
SRC_URI="http://n.ethz.ch/student/dbeyeler/download/ufoai_source_040218.zip
	     http://people.ee.ethz.ch/~baepeter/linux_ufoaidemo.zip"
HOMEPAGE="http://ufo.myexp.de/"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/glibc
	    virtual/x11
		media-libs/jpeg
		media-libs/libvorbis
		media-libs/libogg"

src_unpack() {
	unpack ${A}
	cd source/linux
	epatch ${FILESDIR}/${PV}-Makefile.patch
}

src_compile() {
	cd source/linux
	make build_release \
		 OPTCFLAGS="${CFLAGS}" \
		 || die "make failed"
	cd ../..
}

src_install() {
	dodir ${GAMES_DATADIR}/${PN}
	cp -rf ufo/* ${D}${GAMES_DATADIR}/${PN}
	cd source/linux/releasei386-glibc
	exeinto ${GAMES_DATADIR}/${PN}
	doexe ref_gl.so ref_glx.so ufo
	exeinto ${GAMES_DATADIR}/${PN}/base
	doexe gamei386.so
	games_make_wrapper ufo-ai ./ufo ${GAMES_DATADIR}/${PN}
	prepgamesdirs
}

