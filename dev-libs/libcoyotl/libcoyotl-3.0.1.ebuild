# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcoyotl/libcoyotl-3.0.1.ebuild,v 1.2 2004/05/08 16:57:35 dholm Exp $

DESCRIPTION="A collection of portable C++ classes."
HOMEPAGE="http://www.coyotegulch.com/libcoyotl/"
SRC_URI="http://www.coyotegulch.com/libcoyotl/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""
DEPEND="media-libs/libpng"

src_install() {
	make DESTDIR=${D} install
	dodoc ChangeLog NEWS README
}
