# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/mupen64-glide64/mupen64-glide64-0.7.ebuild,v 1.9 2007/02/22 05:23:18 mr_bones_ Exp $

inherit flag-o-matic eutils games

MY_P="glide64_${PV/./_}_ME"
DESCRIPTION="An opengl graphics plugin for the mupen64 N64 emulator"
HOMEPAGE="http://mupen64.emulation64.com/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	>=x11-libs/gtk+-2"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-compile.patch" \
		"${FILESDIR}/${P}-inifix.patch" \
		"${FILESDIR}/${P}-gtk2.patch"

	make clean || die "couldn't clean"

	# gcc 3.4 at least has a problem with -O3 and inline asm
	replace-flags -O3 -O2
	# -ftracer is causing bug#122192
	filter-flags -ftracer
	sed -i \
		-e "s:CFLAGS.*=\(.*\):CFLAGS=\1 ${CFLAGS}:" \
		Makefile \
		||  die "sed failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	exeinto "${GAMES_LIBDIR}/mupen64/plugins"
	doexe Glide64.so || die "doexe failed"
	insinto "${GAMES_LIBDIR}/mupen64/plugins"
	doins Glide64.ini
	prepgamesdirs
}
