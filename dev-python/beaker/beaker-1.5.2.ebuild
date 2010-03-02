# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/beaker/beaker-1.5.2.ebuild,v 1.1 2010/03/02 18:50:50 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"
#DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="Beaker"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A simple WSGI middleware to use the Myghty Container API"
HOMEPAGE="http://beaker.groovie.org/ http://pypi.python.org/pypi/Beaker"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/nose dev-python/webtest )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils_src_prepare

	# Disable broken test.
	sed -e "s/^def test_upgrade/def _test_upgrade/" -i tests/test_cache.py
}

src_test() {
	testing() {
		[[ "${PYTHON_ABI}" == 3.* ]] && return
		PYTHONPATH="build-${PYTHON_ABI}/lib" nosetests
	}
	python_execute_function testing
}
