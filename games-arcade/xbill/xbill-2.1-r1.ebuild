# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/xbill/xbill-2.1-r1.ebuild,v 1.7 2005/09/11 02:56:07 agriffis Exp $

inherit games

DESCRIPTION="A game about evil hacker called Bill!"
HOMEPAGE="http://www.xbill.org/"
SRC_URI="http://www.xbill.org/download/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

DEPEND="=x11-libs/gtk+-1*"

src_compile() {
	egamesconf --enable-gtk || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	prepgamesdirs
}
