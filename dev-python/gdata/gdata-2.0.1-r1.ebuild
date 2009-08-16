# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gdata/gdata-2.0.1-r1.ebuild,v 1.1 2009/08/16 19:52:38 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="gdata-${PV}"

DESCRIPTION="Python client library for Google data APIs"
HOMEPAGE="http://code.google.com/p/gdata-python-client/"
SRC_URI="http://gdata-python-client.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

DEPEND=""
RDEPEND="|| ( >=dev-lang/python-2.5 dev-python/elementtree )"

RESTRICT_PYTHON_ABIS="3*"

PYTHON_MODNAME="atom gdata"
S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/run_data_tests.py -v || die "Data tests failed with Python ${PYTHON_ABI}"

		# run_service_tests.py requires interaction (and a valid Google account), so skip it.
		# PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" tests/run_service_tests.py -v || die "Service tests failed with Python ${PYTHON_ABI}"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r samples
	fi
}
