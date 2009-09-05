# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/traits/traits-3.2.0.ebuild,v 1.1 2009/09/05 21:13:04 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="Traits"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Enthought Tool Suite explicitly typed attributes for Python"
HOMEPAGE="http://code.enthought.com/projects/traits"
SRC_URI="http://www.enthought.com/repo/ETS/${MY_P}.tar.gz"

IUSE="doc examples test"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

RDEPEND=">=dev-python/numpy-1.1
	>=dev-python/enthoughtbase-3.0.3"
DEPEND="dev-python/setuptools
	doc? ( dev-python/setupdocs )
	test? ( >=dev-python/nose-0.10.3
			>=dev-python/numpy-1.1 )"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="enthought"

src_prepare() {
	sed -i -e "s/self.run_command('build_docs')/pass/" setup.py || die
}

src_compile() {
	distutils_src_compile
	if use doc; then
		"${python}" setup.py build_docs --formats=html \
			|| die "doc building failed"
	fi
}

src_test() {
	testing() {
		PYTHONPATH="$(dir -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" test
	}
	python_execute_function testing
}

src_install() {
	find "${S}" -name \*LICENSE.txt -delete
	distutils_src_install
	dodoc docs/*.txt
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins -r build/docs/html || die
		doins docs/*.pdf || die
	fi
	if use examples; then
		doins -r examples || die
	fi
}
