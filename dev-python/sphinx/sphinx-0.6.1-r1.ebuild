# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sphinx/sphinx-0.6.1-r1.ebuild,v 1.6 2009/08/09 16:38:17 armin76 Exp $

inherit distutils multilib

MY_PN="Sphinx"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool to create documentation for Python projects"
HOMEPAGE="http://sphinx.pocoo.org/"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 s390 sh sparc ~x86"
IUSE="doc test"

RDEPEND=">=dev-python/pygments-0.8
	>=dev-python/jinja2-2.1
	>=dev-python/docutils-0.4"

DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( dev-python/nose )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	DOCS="CHANGES"
	distutils_src_compile

	if use doc ; then
		cd doc
		PYTHONPATH="../" emake \
			SPHINXBUILD="${python} ../sphinx-build.py" \
			html || die "making docs failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml -A txt -r doc/_build/html/* || die
	fi
}

src_test() {
	PYTHONPATH="./build/lib" "${python}" tests/run.py || die "Tests failed"
}

pkg_postinst() {
	distutils_pkg_postinst

	# Generating the Grammar pickle to avoid on the fly generation causing sandbox violations (bug #266015)
	"${python}" \
		-c "from sphinx.pycode.pgen2.driver import load_grammar ; load_grammar('${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/sphinx/pycode/Grammar.txt')" \
		|| die "generating grammar pickle failed"
}

pkg_postrm() {
	rm "${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/sphinx/pycode"/Grammar*.pickle
	distutils_pkg_postrm
}
