# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/openglad/openglad-0.98.ebuild,v 1.6 2004/06/24 23:16:09 agriffis Exp $

inherit eutils games

DESCRIPTION="An SDL clone of Gladiator, a classic RPG game"
HOMEPAGE="http://snowstorm.sourceforge.net/"
SRC_URI="mirror://sourceforge/snowstorm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND=">=media-libs/sdl-mixer-1.2.5
	>=media-libs/sdl-image-1.2.2
	>=media-libs/libsdl-1.2.0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-gladpack.c.patch
}

src_compile() {
	egamesconf \
		--prefix=/usr \
		--bindir="${GAMES_BINDIR}" \
		--datadir="${GAMES_DATADIR}/${PN}" \
		 || die
	emake || die "emake failed"
}

src_install() {
	make install \
		DESTDIR=${D} \
		docdir=${D}/usr/share/doc/${PF} \
		|| die "make install failed"
	prepalldocs
	prepgamesdirs
}
