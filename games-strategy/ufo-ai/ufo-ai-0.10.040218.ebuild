# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/ufo-ai/ufo-ai-0.10.040218.ebuild,v 1.10 2004/06/24 23:29:50 agriffis Exp $

inherit eutils games flag-o-matic

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="http://ufo.myexp.de/"
SRC_URI="http://n.ethz.ch/student/dbeyeler/download/ufoai_source_040218.zip
	http://people.ee.ethz.ch/~baepeter/linux_ufoaidemo.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/glibc
	virtual/x11
	media-libs/jpeg
	media-libs/libvorbis
	media-libs/libogg"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd source/linux
	epatch ${FILESDIR}/${PV}-Makefile.patch
}

src_compile() {
	filter-flags -fstack-protector #51116
	cd ${S}/source/linux
	make build_release \
		OPTCFLAGS="${CFLAGS}" \
		|| die "make failed"
}

src_install() {
	dodir ${GAMES_DATADIR}/${PN}
	cp -rf ${S}/ufo/* ${D}${GAMES_DATADIR}/${PN} || die "copying data"
	if [ ${ARCH} == x86 ]; then
		ARCH=i386
	fi
	exeinto ${GAMES_DATADIR}/${PN}
	doexe ${S}/source/linux/release${ARCH}-glibc/{ref_gl.so,ref_glx.so,ufo} \
		|| "doexe ufo"
	exeinto ${GAMES_DATADIR}/${PN}/base
	doexe ${S}/source/linux/release${ARCH}-glibc/game${ARCH}.so \
		|| die "doexe game${ARCH}.so"
	games_make_wrapper ufo-ai ./ufo ${GAMES_DATADIR}/${PN}
	prepgamesdirs
}
