# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libevocosm/libevocosm-2.5.2.ebuild,v 1.4 2004/06/24 23:16:19 agriffis Exp $

DESCRIPTION="A C++ framework for evolutionary computing"
HOMEPAGE="http://www.coyotegulch.com/libevocosm/"
SRC_URI="http://www.coyotegulch.com/libevocosm/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""
DEPEND="dev-libs/libcoyotl"

src_install() {
	make DESTDIR=${D} install
	dodoc ChangeLog NEWS README
}
