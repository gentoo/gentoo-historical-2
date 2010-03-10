# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/shaaft/shaaft-0.5.0.ebuild,v 1.13 2010/03/10 21:34:58 ssuominen Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="A falling block game similar to Blockout"
HOMEPAGE="http://criticalmass.sourceforge.net/shaaft.php"
SRC_URI="mirror://sourceforge/criticalmass/${P/s/S}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	sys-libs/zlib
	media-libs/libpng
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image"

S=${WORKDIR}/${P/s/S}

src_prepare() {
	sed -i \
		-e 's:DATA_DIR:"'${GAMES_DATADIR}'\/'${PN/s/S}\/'":g' \
		game/main.cpp \
		|| die "sed main.cpp failed"

	sed -i \
		-e 's:png12:png:g' \
		configure.in || die

	epatch \
		"${FILESDIR}"/${P}-gcc34.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-gcc43.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}/${GAMES_BINDIR}"/Packer
	dodoc TODO.txt
	prepgamesdirs
}
