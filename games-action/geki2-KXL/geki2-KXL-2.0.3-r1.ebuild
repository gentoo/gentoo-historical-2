# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/geki2-KXL/geki2-KXL-2.0.3-r1.ebuild,v 1.2 2003/12/31 16:37:58 vapier Exp $

inherit games

DESCRIPTION="2D length scroll shooting game"
HOMEPAGE="http://kxl.hn.org/"
SRC_URI="http://kxl.hn.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=dev-games/KXL-1.1.4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-gentoo-paths.patch
	aclocal || die "aclocal failed"
	automake -a || die "automake failed"
	autoconf || die "autoconf failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ChangeLog COPYING README
	prepgamesdirs
}
