# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/game-launcher/game-launcher-0.9.8.ebuild,v 1.6 2005/09/26 17:50:44 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="universal front end for emulators ... works with MAME, Nesticle, RockNES, zSNES, snes9x, Callus, Stella, z26, and Genecyst"
HOMEPAGE="http://www.dribin.org/dave/game_launcher/"
SRC_URI="mirror://sourceforge/glaunch/gl${PV//./}s.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND=">=media-libs/allegro-4.0.0
	>=media-libs/loadpng-0.11
	>=media-libs/allegromp3-2.0.2
	>=media-libs/allegttf-2.0
	>=media-libs/libpng-1.2.4
	>=media-libs/jpgalleg-1.1
	>=sys-libs/zlib-1.1.4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/glaunch"

src_unpack() {
	unpack ${A}
	cd ${S}

	edos2unix `find -regex '.*\.[ch]' -or -name '*.cc'`
	epatch "${FILESDIR}/${PV}-gentoo.patch"
	find . -name ".cvsignore" -exec rm -f \{\} \;
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	dodir "/opt/${P}"
	cp -R ${S}/* "${D}/opt/${P}"  # doinst can't do recursive
	prepgamesdirs
}
