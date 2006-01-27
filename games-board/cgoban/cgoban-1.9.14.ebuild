# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/cgoban/cgoban-1.9.14.ebuild,v 1.7 2006/01/27 00:40:16 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="A Go-frontend"
HOMEPAGE="http://cgoban1.sourceforge.net/"
SRC_URI="mirror://sourceforge/cgoban1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-gfx/imagemagick
	|| (
		(
			x11-libs/libX11
			x11-libs/libXt )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| (
		x11-proto/xproto
		virtual/x11 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp cgoban_icon.png ${PN}.png || die "cp failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
	doicon ${PN}.png
	make_desktop_entry cgoban Cgoban
	prepgamesdirs
}
