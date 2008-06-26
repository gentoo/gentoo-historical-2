# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/pyephem/pyephem-3.7.2.4.ebuild,v 1.1 2008/06/26 12:06:17 bicatali Exp $

inherit distutils

DESCRIPTION="Astronomical routines for the python programming language"
LICENSE="LGPL-3"
HOMEPAGE="http://rhodesmill.org/pyephem/pyephem.html"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""

src_test() {
	# remove a buggy test (it's a doc test), check next version.
	mv src/ephem/tests/test_rst.py{,orig}
	${python} setup.py test || die "tests failed"
}

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}
	mv "${D}"/usr/lib*/${python}*/site-packages/ephem/doc \
		"${D}"/usr/share/doc/${PF}/html || die "Failed to install doc"
}
