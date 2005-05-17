# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/gunocide2ex/gunocide2ex-1.0.ebuild,v 1.9 2005/05/17 17:38:28 wolf31o2 Exp $

inherit eutils toolchain-funcs games

DESCRIPTION="fast-paced 2D shoot'em'up"
HOMEPAGE="http://www.polyfrag.com/content/product_gunocide.html"
SRC_URI="mirror://sourceforge/g2ex/g2ex-setup.run"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S="${WORKDIR}"

src_unpack() {
	unpack_makeself
	sed -i "s:-g:${CFLAGS}:" makefile \
		|| die "sed makefile failed"
	mkdir binary
	epatch ${FILESDIR}/${PV}-gcc3.patch
	edos2unix config.cfg
	sed -i \
		-e "s:/usr/local/games/gunocide2ex/config\.cfg:${GAMES_SYSCONFDIR}/${PN}.cfg:" \
		-e "s:/usr/local/games/gunocide2ex/hscore\.dat:${GAMES_STATEDIR}/${PN}-hscore.dat:" \
		src/*.{h,cpp} \
			|| die "sed failed"
	sed -i \
		-e "s:/usr/local/games:${GAMES_DATADIR}:" \
		src/*.{h,cpp} `find gfx -name '*.txt'` \
			|| die "sed failed (2)"
}

src_compile() {
	local cc=$(tc-getCXX)

	cd src
	for f in *.cpp ; do
		echo "${cc} ${CFLAGS} `sdl-config --cflags` ${f}"
		${cc} ${cflags} `sdl-config --cflags` -c ${f} || \
			die "couldnt compile ${f}"
	done
	${cc} -o ${PN} *.o -lpthread -lSDL -lSDL_ttf -lSDL_mixer || \
		die "couldnt produce binary"
}

src_install() {
	dogamesbin src/${PN}               || die "dogamesbin failed"
	dosym ${PN} "${GAMES_BINDIR}/g2ex" || die "dosym failed"
	dodir "${GAMES_DATADIR}/${PN}"
	cp -R gfx sfx lvl credits arial.ttf "${D}/${GAMES_DATADIR}/${PN}/" \
		|| die "cp failed"
	insinto "${GAMES_SYSCONFDIR}"
	newins config.cfg ${PN}.cfg        || die "newins failed (cfg)"
	insinto "${GAMES_STATEDIR}"
	newins hscore.dat ${PN}-hscore.dat || die "newins failed (hscore)"
	dodoc history doc/MANUAL_DE        || die "dodoc failed"
	dohtml doc/manual_de.html          || die "dohtml failed"
	prepgamesdirs
}
