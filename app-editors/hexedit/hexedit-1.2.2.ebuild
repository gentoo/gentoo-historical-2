# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/hexedit/hexedit-1.2.2.ebuild,v 1.15 2004/06/27 22:13:31 vapier Exp $

DESCRIPTION="View and edit files in hex or ASCII"
HOMEPAGE="http://www.chez.com/prigaux/hexedit.html"
SRC_URI="http://merd.net/pixel/${P}.src.tgz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64"
IUSE=""

DEPEND="virtual/libc
	sys-libs/ncurses"
RDEPEND="sys-libs/ncurses"

S=${WORKDIR}/hexedit

src_install() {
	dobin hexedit || die
	doman hexedit.1
	dodoc Changes TODO
}
