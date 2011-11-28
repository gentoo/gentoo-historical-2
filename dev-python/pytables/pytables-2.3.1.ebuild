# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytables/pytables-2.3.1.ebuild,v 1.2 2011/11/28 20:09:23 hwoarang Exp $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

MY_PN=tables
MY_P=${MY_PN}-${PV}

inherit distutils

DESCRIPTION="A package for managing hierarchical datasets built on top of the HDF5 library."
HOMEPAGE="http://www.pytables.org http://pypi.python.org/pypi/tables"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"
IUSE="doc contrib examples"

RDEPEND="
	sci-libs/hdf5
	dev-python/numpy
	dev-python/numexpr
	dev-libs/lzo:2
	app-arch/bzip2"
DEPEND="${RDEPEND}
	dev-python/cython"

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MY_P}

DOCS="ANNOUNCE.txt MIGRATING_TO_2.x.txt RELEASE_NOTES.txt THANKS doc/usersguide-${PV}.pdf"

src_compile() {
	export HDF5_DIR="${EPREFIX}"/usr
	distutils_src_compile
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" tables/tests/test_all.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	pushd doc > /dev/null
	use doc && dohtml -r html/*

	insinto /usr/share/doc/${PF}
	doins -r scripts
	popd > /dev/null

	insinto /usr/share/${PF}
	use contrib && doins -r contrib
}
