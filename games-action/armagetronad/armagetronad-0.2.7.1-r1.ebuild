# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/armagetronad/armagetronad-0.2.7.1-r1.ebuild,v 1.3 2006/10/28 07:40:37 tupone Exp $


inherit flag-o-matic eutils games

DESCRIPTION="3d tron lightcycles, just like the movie"
HOMEPAGE="http://armagetronad.sourceforge.net/"
SRC_URI="mirror://sourceforge/armagetronad/${P}.tar.bz2
	!dedicated? (
		http://armagetron.sourceforge.net/addons/moviesounds_fq.zip
		http://armagetron.sourceforge.net/addons/moviepack.zip
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="dedicated"

RDEPEND="
	!dedicated? (
		sys-libs/zlib
		virtual/opengl
		virtual/glu
		media-libs/libsdl
		media-libs/sdl-image
		media-libs/jpeg
		media-libs/libpng )"
DEPEND="${RDEPEND}
	!dedicated? ( app-arch/unzip )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-security-1.patch
	if use dedicated; then
		cp "${FILESDIR}"/${PN}-ded .
		sed -i \
			-e "s:@GAMES_SYSCONFDIR@:${GAMES_SYSCONFDIR}:" \
			-e "s:@GAMES_LIBDIR@:${GAMES_LIBDIR}:" \
			-e "s:@GAMES_DATADIR@:${GAMES_DATADIR}:" \
			${PN}-ded
	fi
}

src_compile() {
	filter-flags -fno-exceptions
	if use dedicated; then
		egamesconf --disable-glout || die "egamesconf failed"
	else
		egamesconf || die "egamesconf failed"
	fi
	emake || die "emake failed"
	make documentation || "make doc failed"
}

src_install() {
	dohtml doc/*.html
	docinto html/net
	dohtml doc/net/*.html
	newicon tron.ico ${PN}.ico
	exeinto "${GAMES_LIBDIR}/${PN}"
	if use dedicated; then
		doexe src/tron/${PN}-dedicated || die "copying files"
	else
		doexe src/tron/${PN} || die "copying files"
	fi
	doexe src/network/armagetronad-* || die "copying files"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r log language || die "copying files"
	if ! use dedicated; then
		doins -r arenas models sound textures music || die "copying files"
	fi
	insinto "${GAMES_SYSCONFDIR}/${PN}"
	doins -r config/* || die "copying files"
	if use dedicated; then
		dogamesbin ${PN}-ded
	fi
	cd "${S}"
	insinto "${GAMES_DATADIR}/${PN}"
	if ! use dedicated; then
		dogamesbin "${FILESDIR}/${PN}"
		insinto "${GAMES_DATADIR}/${PN}"
		doins -r ../moviepack ../moviesounds || die "copying movies"
		make_desktop_entry armagetronad "Armagetron Advanced" ${PN}.ico
	fi
	prepgamesdirs
}
