# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/red-blue-quake2/red-blue-quake2-0.1.ebuild,v 1.5 2004/11/03 00:24:45 vapier Exp $

inherit games eutils

DESCRIPTION="red-blue Quake II !  play quake2 w/3d glasses !"
HOMEPAGE="http://www.jfedor.org/red-blue-quake2/"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/source/q2source-3.21.zip
	ftp://ftp.algx.net/idsoftware/source/q2source-3.21.zip
	http://ftp.gentoo.skynet.be/pub/ftp.idsoftware.com/source/q2source-3.21.zip
	http://www.jfedor.org/red-blue-quake2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/x11"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/quake2-3.21/linux

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PV}-gentoo.patch
	cd quake2-3.21/linux
	sed -i "s:GENTOO_DIR:${GAMES_LIBDIR}/${PN}:" sys_linux.c
	sed -i "s:/etc/quake2.conf:${GAMES_SYSCONFDIR}/${PN}.conf:" sys_linux.c vid_so.c
}

src_compile() {
	mkdir -p releasei386-glibc/ref_soft
	make \
		GENTOO_CFLAGS="${CFLAGS}" \
		GENTOO_DATADIR=${GAMES_DATADIR}/quake2-data/baseq2/ \
		build_release || die
}

src_install() {
	cd release*

	exeinto ${GAMES_LIBDIR}/${PN}
	doexe gamei386.so ref_softx.so
	exeinto ${GAMES_LIBDIR}/${PN}/ctf
	doexe ctf/gamei386.so
	newgamesbin quake2 red-blue-quake2

	dodir ${GAMES_DATADIR}/quake2-data

	insinto ${GAMES_SYSCONFDIR}
	echo ${GAMES_LIBDIR}/${PN} > ${PN}.conf
	doins ${PN}.conf

	prepgamesdirs
}
