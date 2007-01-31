# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/skstream/skstream-0.3.6.ebuild,v 1.1 2007/01/31 20:48:43 tupone Exp $

DESCRIPTION="FreeSockets - Portable C++ classes for IP (sockets) applications"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"
HOMEPAGE="http://www.worldforge.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""

src_install() {
	make DESTDIR="${D}" install || die "make install died"
	dodoc AUTHORS ChangeLog NEWS README README.FreeSockets TODO
}
