# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cgdb/cgdb-0.5.0.ebuild,v 1.3 2005/01/12 11:52:11 ka0ttic Exp $

DESCRIPTION="curses interface to the GNU debugger"
HOMEPAGE="http://sourceforge.net/projects/cgdb"
SRC_URI="mirror://sourceforge/cgdb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.3-r1"
RDEPEND="${DEPEND}
	>=sys-devel/gdb-5.3"

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	einstall || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
