# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/discover-data/discover-data-2.2005.02.13.ebuild,v 1.2 2005/10/10 14:23:31 vapier Exp $

DESCRIPTION="data for discover. list of pci ids. pnp ids etc."
HOMEPAGE="http://alioth.debian.org/projects/pkg-discover/"
SRC_URI="http://archive.progeny.com/progeny/discover/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc -sparc ~x86"
IUSE=""

DEPEND=""

src_install() {
	make prefix=/usr DESTDIR="${D}" install || die
}
