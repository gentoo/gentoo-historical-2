# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/chkrootkit/chkrootkit-0.42b.ebuild,v 1.13 2004/06/29 19:22:55 agriffis Exp $

inherit eutils flag-o-matic

DESCRIPTION="a tool to locally check for signs of a rootkit"
HOMEPAGE="http://www.chkrootkit.org/"
SRC_URI="ftp://ftp.pangeia.com.br/pub/seg/pac/${P}.tar.gz"

LICENSE="AMS"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~ia64 amd64"
IUSE=""

DEPEND="virtual/libc
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	sed -i 's:${head} -:${head} -n :' chkrootkit
}

src_compile() {
	filter-ldflags -pie
	make sense || die
	make strings || die
}

src_install() {
	dosbin check_wtmpx chklastlog chkproc chkrootkit chkwtmp ifpromisc || die
	newsbin strings strings-static || die
	dodoc README README.chklastlog README.chkwtmp
}
