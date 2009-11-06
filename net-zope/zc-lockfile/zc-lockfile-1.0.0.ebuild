# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zc-lockfile/zc-lockfile-1.0.0.ebuild,v 1.2 2009/11/06 16:52:47 volkmar Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Basic inter-process locks"
HOMEPAGE="http://pypi.python.org/pypi/zc.lockfile"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~ppc"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/nose net-zope/zope-testing )"
RDEPEND=""

S="${WORKDIR}"/${MY_P}

PYTHON_MODNAME="${PN/-//}"
DOCS="doc.txt src/zc/lockfile/CHANGES.txt src/zc/lockfile/README.txt"

src_test() {
	testing() {
		# Future versions of dev-python/nose will support Python 3.
		[[ "${PYTHON_ABI}" == 3.* ]] && return

		PYTHONPATH="build-${PYTHON_ABI}/lib" nosetests-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	rm -f "${D}"usr/$(get_libdir)/python*/site-packages/zc/lockfile/{tests.py,*.txt}
}
