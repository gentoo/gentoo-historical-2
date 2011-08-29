# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/blobwars/blobwars-1.19.ebuild,v 1.1 2011/08/29 18:43:08 pacho Exp $

EAPI="3"

inherit eutils gnome2-utils games

DESCRIPTION="Platform game about a blob and his quest to rescue MIAs from an alien invader"
HOMEPAGE="http://sourceforge.net/projects/blobwars/ https://sourceforge.net/apps/mediawiki/blobwars/index.php?title=Main_Page"
SRC_URI="mirror://sourceforge/blobwars/${P}.tar.gz"

LICENSE="BSD CCPL-Attribution-ShareAlike-3.0 CCPL-Attribution-3.0 GPL-2 LGPL-2.1 fairuse public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-image
	media-libs/sdl-net
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.19-linking-order.patch"
	epatch "${FILESDIR}/${PN}-1.19-ldflags.patch"
	sed -i -e "/-Werror/d" makefile || die
}

src_compile() {
	emake \
		USEPAK="1" \
		DATADIR="${GAMES_DATADIR}/${PN}/" \
		DOCDIR="/usr/share/doc/${PF}/html/" \
		LOCALEDIR="/usr/share/locale/" || die
}

src_install() {
	emake \
		USEPAK="1" \
		DESTDIR="${D}" \
		BINDIR="${GAMES_BINDIR}/" \
		DATADIR="${GAMES_DATADIR}/${PN}/" \
		DOCDIR="/usr/share/doc/${PF}/html/" \
		ICONDIR="/usr/share/icons/hicolor/" \
		DESKTOPDIR="/usr/share/applications/" \
		LOCALEDIR="/usr/share/locale/" \
			install || die

	# now make the docs Gentoo friendly.
	dodoc "${ED}/usr/share/doc/${PF}/html/"{changes,hacking,porting,readme} || die
	rm -f "${ED}/usr/share/doc/${PF}/html/"{changes,hacking,porting,readme} || die
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
