# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sphinx/sphinx-0.4.2.ebuild,v 1.2 2008/08/01 16:47:52 pythonhead Exp $

inherit distutils

MY_PN="Sphinx"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A tool that makes it easy to create intelligent and beautiful documentation for Python projects."
HOMEPAGE="http://sphinx.pocoo.org/"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="doc test"

RDEPEND=">=dev-python/pygments-0.8
	>=dev-python/jinja-1.1
	>=dev-python/docutils-0.4
	dev-python/setuptools"

DEPEND="${RDEPEND}
	test? ( dev-python/nose )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	DOCS="CHANGES"
	distutils_src_compile

	if use doc ; then
		cd doc
		PYTHONPATH="../" emake SPHINXBUILD="${python} ../sphinx-build.py" html || die "making docs failed"
	fi
}

src_install() {
	distutils_src_install
	if use doc ; then
		dohtml -A txt -r doc/_build/html/*
	fi
}

src_test() {
	#Tests fail without this directory, fixed in next release
	#http://bugs.python.org/issue3484
	mkdir tests/root/_build
	PYTHONPATH=. "${python}" tests/run.py || die "Tests failed"
}
