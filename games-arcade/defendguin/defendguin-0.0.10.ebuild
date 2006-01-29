# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/defendguin/defendguin-0.0.10.ebuild,v 1.6 2006/01/29 00:00:27 joshuabaergen Exp $

inherit eutils games
DESCRIPTION="A clone of the arcade game Defender, but with a Linux theme"
HOMEPAGE="http://www.newbreedsoftware.com/defendguin/"
SRC_URI="ftp://ftp.sonic.net/pub/users/nbs/unix/x/defendguin/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="media-libs/sdl-mixer
	media-libs/libsdl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-makefile.patch"
	rm -f data/images/*.sh
}

src_install() {
	dogamesbin defendguin || die "dogamesbin failed"
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r ./data/* "${D}/${GAMES_DATADIR}/${PN}" || die "cp failed"
	prepgamesdirs
}
