# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cffi/cffi-0.8.1.ebuild,v 1.5 2014/03/04 20:53:08 naota Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} pypy2_0 )

inherit distutils-r1

DESCRIPTION="Foreign Function Interface for Python calling C code."
HOMEPAGE="http://cffi.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa x86 ~x86-fbsd"
IUSE="doc test"

RDEPEND="virtual/libffi
	dev-python/pycparser[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/hgdistver"
DEPEND="$REDEPEND
	test? ( dev-python/virtualenv )"

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	py.test -x -v --ignore testing/test_zintegration.py c/ testing/
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dohtml -r doc/build/
}
