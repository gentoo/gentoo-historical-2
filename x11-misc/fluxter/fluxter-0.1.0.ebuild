# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fluxter/fluxter-0.1.0.ebuild,v 1.10 2004/06/24 22:18:55 agriffis Exp $

DESCRIPTION="workspace pager dockapp, particularly useful with the Fluxbox window manager"
HOMEPAGE="http://www.isomedia.com/homes/stevencooper/"
SRC_URI="http://www.isomedia.com/homes/stevencooper/files/${P}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

DEPEND="virtual/blackbox"

src_compile() {
	econf --datadir=/usr/share/commonbox || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README COPYING AUTHORS ChangeLog NEWS README TODO
}
