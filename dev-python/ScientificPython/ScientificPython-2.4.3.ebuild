# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ScientificPython/ScientificPython-2.4.3.ebuild,v 1.7 2004/06/25 01:49:40 agriffis Exp $

inherit distutils

IUSE=""
DESCRIPTION="Scientific Module for Python"
SRC_URI="http://starship.python.net/~hinsen/ScientificPython/${P}.tar.gz"
HOMEPAGE="http://starship.python.net/crew/hinsen/scientific.html"
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~sparc ~alpha"

DEPEND="virtual/python
	>=dev-python/numeric-19.0
	>=app-sci/netcdf-3.0"


src_install() {
	distutils_src_install

	dodoc MANIFEST.in COPYRIGHT README*
	cd Doc
	dodoc CHANGELOG
	dohtml HTML/*

	dodir /usr/share/doc/${PF}/pdf
	insinto /usr/share/doc/${PF}/pdf
	doins PDF/*
}
