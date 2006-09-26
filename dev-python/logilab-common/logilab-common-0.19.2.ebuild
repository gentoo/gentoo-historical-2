# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/logilab-common/logilab-common-0.19.2.ebuild,v 1.1 2006/09/26 23:49:28 marienz Exp $

inherit distutils

DESCRIPTION="Several modules providing low level functionality shared among some python projects developed by logilab."
HOMEPAGE="http://www.logilab.org/projects/common/"
SRC_URI="ftp://ftp.logilab.org/pub/common/${P#logilab-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="doc"

DEPEND="|| ( >=dev-python/optik-1.4 >=dev-lang/python-2.3 )
	test? ( dev-python/egenix-mx-base )"

PYTHON_MODNAME="logilab"


src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/html/*
	fi
}

src_test() {
	# The tests will not work properly from the source dir, so do a
	# temporary install:
	local spath="test/lib/python"
	"${python}" setup.py install --home="${T}/test" || die "test copy failed"
	# dir needs to be this or the tests fail
	cd "${T}/${spath}/logilab/common/test"

	# These tests will fail:
	rm unittest_db.py
	has userpriv ${FEATURES} || rm unittest_fileutils.py

	PYTHONPATH="${T}/${spath}" "${python}" runtests.py || die "tests failed"
	cd "${S}"
	rm -rf "${T}/test"
}
