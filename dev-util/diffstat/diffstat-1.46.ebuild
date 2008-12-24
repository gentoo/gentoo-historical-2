# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/diffstat/diffstat-1.46.ebuild,v 1.2 2008/12/24 21:20:35 vapier Exp $

inherit eutils

DESCRIPTION="creates a histogram from a diff of the insertions, deletions, and modifications per-file"
HOMEPAGE="http://invisible-island.net/diffstat/diffstat.html"
SRC_URI="ftp://invisible-island.net/${PN}/${P}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/diffutils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.37-hard-locale.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README CHANGES
}
