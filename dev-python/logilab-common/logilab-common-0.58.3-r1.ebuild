# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/logilab-common/logilab-common-0.58.3-r1.ebuild,v 1.1 2012/12/30 11:42:11 mgorny Exp $

EAPI=5
# broken with python3.3, bug #449276
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_2} pypy1_9 )

inherit distutils-r1

DESCRIPTION="Useful miscellaneous modules used by Logilab projects"
HOMEPAGE="http://www.logilab.org/project/logilab-common http://pypi.python.org/pypi/logilab-common"
SRC_URI="ftp://ftp.logilab.org/pub/common/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test doc"

# dev-python/unittest2 is not required with Python 2.7+ and 3.2+.
RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/unittest2"

# Tests using dev-python/psycopg are skipped when dev-python/psycopg isn't installed.
DEPEND="${RDEPEND}
	test? (
		dev-python/egenix-mx-base
		!dev-python/psycopg[-mxdatetime]
	)
	doc? ( dev-python/epydoc )"

python_prepare_all() {
	sed -e 's:(CURDIR):{S}/${P}:' -i doc/makefile || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		# Simplest way to make makefile point to the right place.
		ln -s "${BEST_BUILD_DIR}" build || die
		emake -C doc epydoc
		rm build || die
	fi
}

python_test() {
	# The package has to be 'installed' before testing.
	local tpath="${BUILD_DIR}/test"
	local spath="${tpath}$(python_get_sitedir)"

	esetup.py install --root="${tpath}" || die

	# Make sure that the tests use correct modules.
	cd "${spath}" || die
	PYTHONPATH="${spath}:${PYTHONPATH}" \
		"${tpath}${EPREFIX}/usr/bin/pytest" \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	doman doc/pytest.1
	use doc && dohtml -r doc/apidoc/.
}
