# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/diff-match-patch/diff-match-patch-20110725.1.ebuild,v 1.1 2011/12/27 13:07:18 aidecoe Exp $

EAPI=4

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Diff, match and patch algorithms for plain text"
HOMEPAGE="http://code.google.com/p/google-diff-match-patch/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

TEST_SCRIPT="${PN//-/_}/${PN//-/_}_test.py"

src_prepare() {
	python_convert_shebangs -r 2 python2/*
}

src_test() {
	testing() {
		local pylib="build-${PYTHON_ABI}/lib"
		PYTHONPATH="${pylib}" "$(PYTHON)" "${pylib}/${TEST_SCRIPT}"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm "${D}/$(python_get_sitedir)/${TEST_SCRIPT}" || die
	}

	python_execute_function -q delete_tests
}
