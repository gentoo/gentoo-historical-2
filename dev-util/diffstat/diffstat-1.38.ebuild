# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/diffstat/diffstat-1.38.ebuild,v 1.4 2005/04/01 05:36:32 agriffis Exp $

inherit eutils

DESCRIPTION="creates a histogram from a diff of the insertions, deletions, and modifications per-file"
HOMEPAGE="http://invisible-island.net/diffstat/diffstat.html"
SRC_URI="ftp://invisible-island.net/${PN}/${P}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ia64 ~mips ~ppc sparc x86"
IUSE=""

DEPEND="sys-apps/diffutils"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.37-hard-locale.patch
}

src_install() {
	dobin diffstat || die "dobin failed"
	doman diffstat.1 || die "doman failed"
	dodoc README CHANGES
}
