# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/zaz/zaz-0.3.0.ebuild,v 1.3 2009/11/16 22:10:47 maekke Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="A puzzle game where the player has to arrange balls in triplets"
HOMEPAGE="http://sourceforge.net/projects/zaz/"
SRC_URI="mirror://sourceforge/zaz/${P}.tar.gz"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[X,audio,video]
	media-libs/sdl-image[png]
	media-libs/libvorbis
	media-libs/libtheora
	media-libs/ftgl
	virtual/libintl"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--with-applicationdir=/usr/share/applications \
		--with-icondir=/usr/share/pixmaps \
		--localedir=/usr/share/locale \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS ChangeLog
	prepgamesdirs
}
