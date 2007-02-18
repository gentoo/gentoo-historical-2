# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qtorrent/qtorrent-0.9.6.1-r2.ebuild,v 1.3 2007/02/18 20:22:00 weeve Exp $

inherit eutils distutils

DESCRIPTION="QTorrent is a PyQt GUI for BitTorrent."
HOMEPAGE="http://thegraveyard.org/qtorrent.php"
SRC_URI="http://thegraveyard.org/files/${P}.tar.bz2
	mirror://gentoo/${P}-sizetype.patch"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""
DEPEND="dev-python/PyQt"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${DISTDIR}/${P}-sizetype.patch

	# see bug #118234
	sed -e 's/getOpenFileName(None,/getOpenFileName("",/' \
	    -i pyqtorrent/torrentmain.py
}
