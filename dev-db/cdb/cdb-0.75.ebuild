# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/cdb/cdb-0.75.ebuild,v 1.22 2005/08/28 20:04:53 grobian Exp $

inherit eutils toolchain-funcs

DESCRIPTION="fast, reliable, simple package for creating and reading constant databases"
HOMEPAGE="http://cr.yp.to/cdb.html"
SRC_URI="http://cr.yp.to/cdb/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc-macos ~sparc x86"
IUSE=""

DEPEND=">=sys-apps/portage-2.0.47-r10
	>=sys-apps/sed-4
	app-arch/tar
	app-arch/gzip"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-errno.diff

	sed -i \
		-e 's/head -1/head -n 1/g' Makefile || \
			die "sed Makefile failed"
}

src_compile() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC)" > conf-ld
	echo "/usr" > conf-home
	emake || die "emake failed"
}

src_install() {
	dobin cdbdump cdbget cdbmake cdbmake-12 cdbmake-sv cdbstats cdbtest || \
		die "dobin failed"
	newlib.a cdb.a libcdb.a || die "newlib.a failed"
	insinto /usr/include
	doins cdb.h || die "doins failed"

	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION || \
		die "dodoc failed"
}
