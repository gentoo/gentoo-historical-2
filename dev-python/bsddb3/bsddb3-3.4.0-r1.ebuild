# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bsddb3/bsddb3-3.4.0-r1.ebuild,v 1.4 2003/07/12 12:49:25 aliz Exp $

inherit distutils

DESCRIPTION="Python bindings for BerkelyDB"
HOMEPAGE="http://pybsddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/pybsddb/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="virtual/python
	=sys-libs/db-3*"

S="${WORKDIR}/${P}"

DOCS="README.txt TODO.txt"

src_unpack() {
	unpack ${A}
	einfo "Applying ${P}-db3.patch"
	cd ${S}; patch -p0 < ${FILESDIR}/${P}-db3.patch
}

src_install() {
	distutils_src_install
	dohtml docs/*
}

