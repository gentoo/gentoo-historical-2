# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gtkatlantic/gtkatlantic-0.3.1.ebuild,v 1.1 2003/11/13 20:53:56 mr_bones_ Exp $

inherit games

DESCRIPTION="Monopoly-like game that works with the monopd server"
HOMEPAGE="http://gtkatlantic.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtkatlantic/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

DEPEND="=x11-libs/gtk+-1.2*
	>=dev-libs/libxml2-2.4.0
	>=media-libs/libpng-1.0.12"

src_install() {
	make DESTDIR=${D} install           || die "make install failed"
	dodoc README AUTHORS ChangeLog NEWS || die "dodoc failed"
	prepgamesdirs
}
