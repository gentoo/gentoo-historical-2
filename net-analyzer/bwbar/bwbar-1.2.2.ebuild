# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bwbar/bwbar-1.2.2.ebuild,v 1.2 2006/01/13 00:37:09 vanquirius Exp $

DESCRIPTION="The kernel.org \"Current bandwidth utilization\" bar"
HOMEPAGE="http://www.kernel.org/pub/software/web/bwbar/"
SRC_URI="mirror://kernel/software/web/bwbar/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="media-libs/libpng"

src_install() {
	dobin bwbar
	dodoc README
}
