# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/ccze/ccze-0.2.1.ebuild,v 1.7 2004/06/25 16:04:48 vapier Exp $

DESCRIPTION="A flexible and fast logfile colorizer"
HOMEPAGE="http://bonehunter.rulez.org/CCZE.html"
SRC_URI="ftp://bonehunter.rulez.org/pub/ccze/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND="virtual/libc
	sys-libs/ncurses
	dev-libs/libpcre"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog ChangeLog-0.1 NEWS THANKS INSTALL README TODO
}
