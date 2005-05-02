# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/hexxagon/hexxagon-1.0.ebuild,v 1.3 2005/05/02 23:32:22 mr_bones_ Exp $

inherit games

DESCRIPTION="clone of the original DOS game"
HOMEPAGE="http://nesqi.homeip.net/hexxagon/"
SRC_URI="http://nesqi.homeip.net/hexxagon/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-cpp/glibmm-2.4
	>=dev-cpp/gtkmm-2.4
	>=x11-libs/gtk+-2.0"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README
	prepgamesdirs
}
