# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unmakeself/unmakeself-1.1.ebuild,v 1.1 2010/05/28 13:09:14 nyhm Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Makeself archive extractor"
HOMEPAGE="http://www.freshports.org/archivers/unmakeself"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/libarchive[bzip2,zlib]"

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS=-larchive ${PN} || die "emake failed"
}

src_install() {
	dobin unmakeself || die "dobin failed"
}
