# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/duhdraw/duhdraw-2.8.12.ebuild,v 1.3 2004/05/16 08:49:12 vapier Exp $

inherit gcc

DESCRIPTION="ASCII art editor"
HOMEPAGE="http://www.wwco.com/~wls/opensource/duhdraw.php"
SRC_URI="http://www.wwco.com/~wls/opensource/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-libs/ncurses"

src_compile() {
	emake CC="$(gcc-getCC) -s ${CFLAGS}" || die
}

src_install() {
	dobin ansi ansitoc duhdraw || die
	dodoc CREDITS HISTORY TODO READ.ME
}
