# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xvattr/xvattr-1.3.ebuild,v 1.8 2004/06/25 00:54:04 agriffis Exp $

DESCRIPTION="X11 XVideo Querying/Setting Tool from Ogle project"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${P}.tar.gz"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"
SLOT=0
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""
DEPEND="virtual/x11
	=x11-libs/gtk+-1*"
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog COPYING NEWS README
}
