# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/pengupop/pengupop-2.1.8.ebuild,v 1.1 2006/10/12 15:42:31 nyhm Exp $

inherit eutils games

DESCRIPTION="Networked multiplayer-only Puzzle Bubble clone"
HOMEPAGE="http://www.junoplay.com/pengupop"
SRC_URI="http://www.junoplay.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's/-g -Wall -O2/-Wall/' \
		Makefile.in || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
	domenu pengupop.desktop
	doicon pengupop.png
	prepgamesdirs
}
