# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/skstream/skstream-0.2.4.ebuild,v 1.1.1.1 2005/11/30 10:03:53 chriswhite Exp $

DESCRIPTION="FreeSockets - Portable C++ classes for IP (sockets) applications"
SRC_URI="ftp://victor.worldforge.org/pub/worldforge/libs/skstream/${P}.tar.gz"
HOMEPAGE="http://www.worldforge.org"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}
