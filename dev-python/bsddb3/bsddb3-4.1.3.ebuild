# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bsddb3/bsddb3-4.1.3.ebuild,v 1.13 2005/04/24 09:14:18 blubb Exp $

inherit distutils eutils

DESCRIPTION="Python bindings for BerkeleyDB"
HOMEPAGE="http://pybsddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/pybsddb/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc amd64"
IUSE=""

DEPEND="virtual/python
	=sys-libs/db-4.1*"

DOCS="README.txt TODO.txt"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-setup.py.patch
}

src_install() {
	distutils_src_install
	dohtml docs/*
}
