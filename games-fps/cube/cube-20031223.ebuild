# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/cube/cube-20031223.ebuild,v 1.5 2004/05/27 02:25:34 vapier Exp $

inherit eutils games

MY_P="cube_2003_12_23"
DESCRIPTION="open source multiplayer and singleplayer first person shooter game"
HOMEPAGE="http://www.cubeengine.com/"
SRC_URI="mirror://sourceforge/cube/${MY_P}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="x86 ppc hppa"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	sys-libs/zlib
	media-libs/libpng"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S="${WORKDIR}/cube"
CUBE_DATADIR="${GAMES_DATADIR}/${PN}/"

src_unpack() {
	unpack ${A}

	cd ${S}/source
	unzip -qn ${MY_P}_src.zip || die

	cd ${MY_P}_src/src
	epatch ${FILESDIR}/${PV}-gentoo-paths.patch || die
	echo "#define GAMES_DATADIR \"${CUBE_DATADIR}\"" >> tools.h
	echo "#define GAMES_DATADIR_LEN ${#CUBE_DATADIR}" >> tools.h
	sed -i \
		-e "s:packages/:${CUBE_DATADIR}packages/:" \
		renderextras.cpp rendermd2.cpp sound.cpp worldio.cpp \
			|| die "fixing data path failed"
	# enable parallel make
	sed -i \
		-e 's/make -C/$(MAKE) -C/' Makefile \
			|| die "sed Makefile failed"
	edos2unix *.cpp
}

src_compile() {
	cd source/${MY_P}_src/src
	emake CXXOPTFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	dogamesbin source/${MY_P}_src/src/cube_{client,server} \
		|| die "dogamesbin failed"
	exeinto "${GAMES_LIBDIR}/${PN}"
	if [ "${ARCH}" == "x86" ] ; then
		newexe bin_unix/linux_client cube_client
		newexe bin_unix/linux_server cube_server
	elif [ "${ARCH}" == "ppc" ] ; then
		newexe bin_unix/ppc_linux_client cube_client
		newexe bin_unix/ppc_linux_server cube_server
	fi
	dogamesbin ${FILESDIR}/cube_{client,server}-bin \
		|| die "dogamesbin failed (bin)"
	sed -i \
		-e "s:GENTOO_DATADIR:${CUBE_DATADIR}:" \
		-e "s:GENTOO_LIBDIR:${GAMES_LIBDIR}/${PN}:" \
		${D}/${GAMES_BINDIR}/cube_{client,server}-bin

	dodir ${CUBE_DATADIR}
	cp -r *.cfg data packages ${D}/${CUBE_DATADIR} \
		|| die "cp failed"

	dodoc source/${MY_P}_src/src/CUBE_TODO.txt
	dohtml -r docs/
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "You now have 2 clients and 2 servers:"
	einfo "cube_client-bin      prebuilt version (needed to play on public multiplayer servers)"
	einfo "cube_client          custom client built from source"
	einfo "Parallel versions of the server have been installed"
}
