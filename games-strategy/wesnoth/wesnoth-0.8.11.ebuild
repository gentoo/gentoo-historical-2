# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wesnoth/wesnoth-0.8.11.ebuild,v 1.2 2005/05/17 19:03:18 wolf31o2 Exp $

inherit eutils flag-o-matic games

DESCRIPTION="A fantasy turn-based strategy game"
HOMEPAGE="http://www.wesnoth.org/"
SRC_URI="!lite? ( mirror://sourceforge/wesnoth/${P}.tar.gz )
	lite? ( mirror://sourceforge/wesnoth/${PN}-lite-${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="editor gnome kde lite nls server tools"

DEPEND=">=media-libs/libsdl-1.2.7
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/freetype-2
	media-libs/sdl-net
	sys-libs/zlib
	virtual/x11"

src_unpack() {
	if use lite ; then
		unpack ${PN}-lite-${PV}.tar.gz
		S=${WORKDIR}/${PN}-lite-${PV}
	else
		unpack ${P}.tar.gz
	fi
	cd "${S}"
	sed -i \
		-e 's/--expandvars//' configure \
		|| die "sed failed"
}

src_compile() {
	if use lite ; then
		S=${WORKDIR}/${PN}-lite-${PV}
	fi
	cd "${S}"
	filter-flags -ftracer -fomit-frame-pointer
	egamesconf \
		--disable-dependency-tracking \
		$(use_enable server) \
		$(use_enable server campaign-server) \
		$(use_enable editor) \
		$(use_enable tools) \
		$(use_enable nls) \
		$(use_with gnome) \
		$(use_with kde) \
		|| die
	emake || die "emake failed"
}

src_install() {
	if use lite ; then
		S=${WORKDIR}/${PN}-lite-${PV}
	fi
	cd "${S}"
	make DESTDIR="${D}" install || die "make install failed"
	mv "${D}${GAMES_DATADIR}/"{icons,applnk,applications} "${D}/usr/share/"
	dodoc MANUAL changelog
	prepgamesdirs
}
