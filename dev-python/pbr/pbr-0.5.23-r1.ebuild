# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pbr/pbr-0.5.23-r1.ebuild,v 1.1 2014/01/21 01:43:35 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="PBR is a library that injects some useful and sensible default
behaviors into your setuptools run."
HOMEPAGE="https://github.com/openstack-dev/pbr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.12[${PYTHON_USEDEP}]
		~dev-python/flake8-2.0[${PYTHON_USEDEP}]
		dev-python/subunit[${PYTHON_USEDEP}]
		dev-python/mimeparse[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		~dev-python/pyflakes-0.7.2[${PYTHON_USEDEP}]
		~dev-python/pep8-1.4.5[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.2[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.17[${PYTHON_USEDEP}]
		<dev-python/testresources-0.3[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		<dev-python/testscenarios-0.5[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.32[${PYTHON_USEDEP}]
	)"
RDEPEND=">dev-python/pip-1.0[${PYTHON_USEDEP}]"

python_test() {
	# These tests pass run within the source and don't represent failures but rather
	# work outside the sandbox constraints
	sed -e s':test_changelog:_&:' -i pbr/tests/test_packaging.py || die
	sed -e s':test_console_script_develop:_&:' -i pbr/tests/test_core.py || die

	sed -e s':test_authors:_&:' -i pbr/tests/test_packaging.py || die
	sed -e s':test_global_setup_hooks:_&:' -i pbr/tests/test_hooks.py \
		-e s':test_custom_commands_known:_&:' \
		-e s':test_command_hooks:_&:' \
		-i pbr/tests/test_hooks.py
	sed -e s':test_setup_py_keywords:_&:' \
		-e s':test_sdist_git_extra_file:_&:' \
		-e s':test_sdist_extra_file:_&:' \
		-e s':test_console_script_install:_&:' \
		-i pbr/tests/test_core.py || die
	 sed -e s':test_custom_build_py_command:_&:' \
		-i pbr/tests/test_commands.py || die

	testr init
	testr run || die "Testsuite failed under ${EPYTHON}"
	flake8 "${PN}"/tests || die "Run over tests folder by flake8 drew error"
}
