# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oosuite/oosuite-0.38.ebuild,v 1.1 2012/04/20 18:21:29 bicatali Exp $

EAPI=4

# python eclass cruft
SUPPORT_PYTHON_ABIS="1"
PYTHON_USE_WITH="tk?"
RESTRICT_PYTHON_ABIS="2.4"

inherit distutils eutils

MYPN="OOSuite"
MYPID="f/f3"

DESCRIPTION="OpenOpt suite of Python modules for numerical optimization"
HOMEPAGE="http://openopt.org/"
SRC_URI="http://openopt.org/images/${MYPID}/${MYPN}.zip -> ${MYPN}-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples minimal tk"

RDEPEND="dev-python/numpy
	!minimal? (
		dev-python/cvxopt[glpk]
		dev-python/lp_solve
		dev-python/matplotlib
		dev-python/setproctitle
		sci-libs/nlopt[python]
		sci-libs/scipy )"
DEPEND="app-arch/unzip
	dev-python/numpy
	dev-python/setuptools"

S="${WORKDIR}/PythonPackages"

src_prepare() {
	#epatch "${FILESDIR}"/${PN}-0.37-no-init-msg.patch
	OO_DIRS="DerApproximator FuncDesigner OpenOpt SpaceFuncs"
	find . -name "*COPYING*" -delete
	# move all examples and tests to ease installation in proper directory
	mkdir "${WORKDIR}/examples"
	local d e
	for d in ${OO_DIRS}; do
			mkdir "${WORKDIR}/examples/${d}"
		for e in $(find ${d} -type d -name examples -or -name tests -or -name doc); do
			mv ${e} "${WORKDIR}/examples/${d}/" || die
		done
	done
}

src_compile() {
	local d
	for d in ${OO_DIRS}; do
		pushd ${d} > /dev/null
		distutils_src_compile
		popd > /dev/null
	done
}

src_test() {
	testing() {
		local d t oldpath=${PYTHONPATH}
		for d in ${OO_DIRS}; do
			PYTHONPATH="${S}/${d}/build-${PYTHON_ABI}/lib:${PYTHONPATH}"
		done
		export PYTHONPATH
		cd "${WORKDIR}"/examples
		for t in \
			DerApproximator/tests/t_check.py \
			FuncDesigner/examples/sle1.py \
			OpenOpt/examples/nlp_1.py \
			SpaceFuncs/examples/triangle.py
		do
			"$(PYTHON)" ${t}
		done
		export PYTHONPATH=${oldpath}
	}
	python_execute_function testing
}

src_install() {
	local d
	for d in ${OO_DIRS}; do
		pushd ${d} > /dev/null
		distutils_src_install
		popd > /dev/null
	done
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${WORKDIR}"/examples
	fi
}
