# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/discover-data/discover-data-2.2003.02.05.ebuild,v 1.8 2004/06/28 16:04:50 vapier Exp $

DESCRIPTION="data for discover. list of pci ids. pnp ids etc."
HOMEPAGE="http://hackers.progeny.com/discover/"
SRC_URI="http://archive.progeny.com/progeny/discover/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc -sparc mips ~alpha hppa amd64"

DEPEND="virtual/libc"

src_install() {
	make prefix=/usr DESTDIR=${D} install || die
}
