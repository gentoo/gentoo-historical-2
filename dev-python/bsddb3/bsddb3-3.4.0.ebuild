# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bsddb3/bsddb3-3.4.0.ebuild,v 1.1 2002/11/01 16:53:50 foser Exp $

DESCRIPTION="Python bindings for BerkelyDB"
HOMEPAGE="http://pybsddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/pybsddb/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/python
	>=sys-libs/db-3.2"

S="${WORKDIR}/${P}"

src_compile() {
	python setup.py build_ext --inplace || die
}

src_install() {
	python setup.py install --prefix=${D}/usr || die

	dodoc README.txt TODO.txt docs/*
}
