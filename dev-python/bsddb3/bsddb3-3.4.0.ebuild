# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bsddb3/bsddb3-3.4.0.ebuild,v 1.3 2003/04/04 22:52:34 liquidx Exp $

inherit distutils

DESCRIPTION="Python bindings for BerkelyDB"
HOMEPAGE="http://pybsddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/pybsddb/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/python
	=sys-libs/db-3*"

S="${WORKDIR}/${P}"

mydoc="README.txt TODO.txt"

src_install() {
	distutils_src_install
	dohtml docs/*
}

