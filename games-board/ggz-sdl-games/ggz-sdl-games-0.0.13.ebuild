# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ggz-sdl-games/ggz-sdl-games-0.0.13.ebuild,v 1.4 2006/09/28 10:01:09 nyhm Exp $

inherit games

DESCRIPTION="These are the gtk versions of the games made by GGZ Gaming Zone"
HOMEPAGE="http://www.ggzgamingzone.org/"
SRC_URI="http://ftp.belnet.be/packages/ggzgamingzone/ggz/${PV}/${P}.tar.gz
	http://mirrors.ibiblio.org/pub/mirrors/ggzgamingzone/ggz/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~ppc x86"
IUSE=""

DEPEND="~dev-games/libggz-0.0.13
	~dev-games/ggz-client-libs-0.0.13
	>=media-libs/libsdl-1.2.0
	>=media-libs/sdl-image-1.2.0
	>=media-libs/sdl-ttf-1.2.0"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS QuickStart.GGZ README*
	prepgamesdirs
}

