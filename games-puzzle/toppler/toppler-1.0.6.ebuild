# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/toppler/toppler-1.0.6.ebuild,v 1.6 2004/11/05 05:13:15 josejx Exp $

inherit games

DESCRIPTION="Reimplementation of Nebulous using SDL"
HOMEPAGE="http://toppler.sourceforge.net/"
SRC_URI="mirror://sourceforge/toppler/${P}.tar.gz"

KEYWORDS="x86 ~amd64 ~ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE="nls"

DEPEND=">=media-libs/libsdl-1.2.0
	media-libs/sdl-mixer
	sys-libs/zlib
	nls? ( sys-devel/gettext )"

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_enable nls) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install    || die "make install failed"
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
	prepgamesdirs
}
