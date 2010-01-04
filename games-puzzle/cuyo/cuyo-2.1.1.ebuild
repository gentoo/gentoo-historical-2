# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/cuyo/cuyo-2.1.1.ebuild,v 1.2 2010/01/04 15:11:03 ssuominen Exp $

EAPI=2
inherit autotools gnome2-utils versionator games

MY_P=${PN}-$(get_version_component_range 1).~-$(get_version_component_range 2-3)
DESCRIPTION="highly addictive and remotely related to tetris"
HOMEPAGE="http://www.karimmi.de/cuyo/"
SRC_URI="http://savannah.nongnu.org/download/cuyo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="+music"

DEPEND="sys-libs/zlib
	media-libs/libsdl[audio,video]
	media-libs/sdl-mixer
	music? ( media-libs/sdl-mixer[mikmod] )
	media-libs/sdl-image"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
