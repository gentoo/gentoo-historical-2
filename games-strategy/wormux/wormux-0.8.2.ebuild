# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wormux/wormux-0.8.2.ebuild,v 1.5 2009/02/04 03:14:25 mr_bones_ Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="A free Worms clone"
HOMEPAGE="http://www.wormux.org/"
SRC_URI="http://download.gna.org/wormux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug nls unicode"

RDEPEND="media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/sdl-net
	media-libs/sdl-gfx
	media-libs/libpng
	net-misc/curl
	media-fonts/dejavu
	>=dev-cpp/libxmlpp-2.6
	nls? ( virtual/libintl )
	unicode? ( dev-libs/fribidi )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/AX_CFLAGS_WARN_ALL/d" \
		-e "s/-Werror//g" \
		-e "s/fribidi-config/pkg-config fribidi/g" \
		configure.ac \
		|| die "sed failed"
	sed -i \
		-e "/xdg/d" \
		-e "/pixmaps/d" \
		data/Makefile.am \
		|| die "sed failed"
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--with-localedir-name=/usr/share/locale \
		--with-datadir-name="${GAMES_DATADIR}/${PN}" \
		--with-font-path=/usr/share/fonts/dejavu/DejaVuSans.ttf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable unicode fribidi) \
		|| die "configuration failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
	newicon data/wormux.svg wormux.svg
	make_desktop_entry wormux Wormux
	prepgamesdirs
}
