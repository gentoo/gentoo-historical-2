# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/ltris/ltris-1.0.14.ebuild,v 1.1 2009/12/30 18:25:42 mr_bones_ Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="very polished Tetris clone"
HOMEPAGE="http://lgames.sourceforge.net/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls"

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
	newicon icons/ltris48.xpm ${PN}.xpm
	make_desktop_entry ltris LTris
	prepgamesdirs
}
