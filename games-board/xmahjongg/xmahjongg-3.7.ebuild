# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/xmahjongg/xmahjongg-3.7.ebuild,v 1.4 2006/12/01 21:07:41 wolf31o2 Exp $

inherit games

DESCRIPTION="friendly GUI version of xmahjongg"
HOMEPAGE="http://www.lcdf.org/xmahjongg/"
SRC_URI="http://www.lcdf.org/xmahjongg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 mips ppc ~ppc-macos x86"
IUSE=""

RDEPEND="x11-libs/libSM
	x11-libs/libX11
	media-libs/libpng
	sys-libs/zlib"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	prepgamesdirs
}
