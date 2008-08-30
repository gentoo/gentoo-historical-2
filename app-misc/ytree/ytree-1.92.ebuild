# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ytree/ytree-1.92.ebuild,v 1.1 2008/08/30 20:13:46 jokey Exp $

DESCRIPTION="A (curses-based) file manager"
HOMEPAGE="http://www.han.de/~werner/ytree.html"
SRC_URI="http://www.han.de/~werner/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/readline
	sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin ytree
	doman ytree.1
}
