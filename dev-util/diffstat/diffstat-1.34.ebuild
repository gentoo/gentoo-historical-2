# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/diffstat/diffstat-1.34.ebuild,v 1.5 2004/06/25 02:29:02 agriffis Exp $

inherit eutils

S=${WORKDIR}/${P}
DESCRIPTION="diffstat reads the output of diff and displays a histogram of the insertions, deletions, and modifications per-file"
SRC_URI="ftp://invisible-island.net/${PN}/${PN}-${PV}.tgz"
HOMEPAGE="http://dickey.his.com/diffstat/diffstat.html"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc ppc mips ~amd64"

DEPEND="sys-apps/diffutils"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-hard-locale.patch
}

src_install() {
	dobin diffstat
	doman diffstat.1
	dodoc README CHANGES
}
