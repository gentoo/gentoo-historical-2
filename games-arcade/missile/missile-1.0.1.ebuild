# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/missile/missile-1.0.1.ebuild,v 1.5 2004/05/07 20:43:18 ciaranm Exp $

inherit eutils games

DESCRIPTION="The game Missile Command for Linux"
HOMEPAGE="http://missile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2.4
	>=media-libs/sdl-image-1.2.1
	>=media-libs/sdl-mixer-1.2.4
	media-libs/libpng"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PV}-Makefile-path-fix.patch"
	sed -i \
		-e "/^game_prefix/s:=GENTOO:=${GAMES_PREFIX}:" \
		-e "/^game_bin/s:=GENTOO:=${GAMES_PREFIX}/bin:" \
		-e "/^game_data/s:=GENTOO:=${GAMES_DATADIR}/${PN}:" \
		-e "/^game_icons/s:=GENTOO:=/usr/share/pixmaps/${PN}:" \
		-e "/^install_as_owner/s:=GENTOO:=${GAMES_USER}:" \
		-e "/^install_as_group/s:=GENTOO:=${GAMES_GROUP}:" \
		Makefile \
			|| die "sed failed"
}

src_compile() {
	emake MYOPTS="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README INSTALL
	prepgamesdirs
}
