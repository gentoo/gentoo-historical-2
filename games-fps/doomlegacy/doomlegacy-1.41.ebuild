# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doomlegacy/doomlegacy-1.41.ebuild,v 1.1 2003/10/11 05:15:33 vapier Exp $

inherit games eutils

DESCRIPTION="Doom legacy, THE doom port"
HOMEPAGE="http://legacy.newdoom.com/"
SRC_URI="mirror://sourceforge/doomlegacy/legacy_${PV/./}_src.tar.gz
	mirror://sourceforge/doomlegacy/legacy.dat.gz
	http://www.lbjhs.net/~jessh/lsdldoom/doom1.wad.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

DEPEND="x86? ( >=dev-lang/nasm-0.98 )
	>=sys-apps/sed-4
	virtual/opengl
	virtual/x11"

S=${WORKDIR}/legacy_${PV//.}_src

src_unpack() {
	unpack ${A}
	mkdir bin
	cd ${S}
	epatch ${FILESDIR}/${PV}-errno.patch
	epatch ${FILESDIR}/${PV}-makefile.patch

	# disable logfile writing
	sed -i 's:#define LOGMESSAGES::' doomdef.h || die 'sed doomdef.h failed'

	# make sure the games can find the wads/data files
	sed -i \
		"/#define DEFAULTWADLOCATION1s/s:\".*\":\"${GAMES_DATADIR}/${PN}\":" \
		linux_x/i_system.c

	# move opengl lib file because it's not useful to anyone else
	sed -i "s:\"r_opengl:\"${GAMES_LIBDIR}/${PN}/r_opengl:" linux_x/i_video_xshm.c

	cd linux_x/musserv
	make -f Makefile.linux clean
}

src_compile() {
	# this is ugly but it's late (here) and it works
	local useasm=
	[ `use x86` ] && useasm="USEASM=1"
	local redosnd=0
	make \
		EXTRAOPTS="${CFLAGS}" \
		LINUX=1 \
		X=1 \
		${useasm} \
		|| redosnd=1
	if [ ${redosnd} -eq 1 ] ; then
		cd linux_x/sndserv
		make clean || die "clean snd srv failed"
		make EXTRAOPTS="${CFLAGS}" || die "snd serv failed"
	fi
	cd ${S}
	make \
		EXTRAOPTS="${CFLAGS}" \
		LINUX=1 \
		X=1 \
		${useasm} \
		|| die "build failed"
}

src_install() {
	dogamesbin \
		linux_x/musserv/linux/musserver \
		linux_x/sndserv/linux/llsndserv \
		${WORKDIR}/bin/llxdoom
	exeinto ${GAMES_LIBDIR}/${PN}
	doexe ${WORKDIR}/bin/r_opengl.so

	insinto ${GAMES_DATADIR}/${PN}
	doins ${WORKDIR}/{legacy.dat,doom1.wad}

	dohtml _doc/*.html
	rm _doc/*.html
	dodoc _doc/*
	prepgamesdirs
}
