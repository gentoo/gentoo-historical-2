# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/ppracer/ppracer-0.3.1.ebuild,v 1.1 2005/03/01 17:16:54 mr_bones_ Exp $

inherit flag-o-matic gnuconfig games

DESCRIPTION="take on the role of Tux, the Linux Penguin, as he races down steep, snow-covered mountains"
HOMEPAGE="http://developer.berlios.de/projects/ppracer/"
SRC_URI="http://download.berlios.de/ppracer/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86 ~ppc"
IUSE="X"

DEPEND="virtual/opengl
	virtual/glu
	X? ( virtual/x11 )
	>=dev-lang/tcl-8.4
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/libpng
	>=media-libs/freetype-2
	sys-libs/zlib"

src_unpack() {
	unpack ${A}
	cd "${S}"
	gnuconfig_update
	autoconf || die "autoconf failed"
}

src_compile() {
	# alpha needs -mieee for this game to avoid FPE
	use alpha && append-flags -mieee

	egamesconf \
		--disable-dependency-tracking \
		--with-data-dir="${GAMES_DATADIR}/${PN}" \
		$(use_with X x) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog
	dohtml -r html/*
	prepgamesdirs
}
