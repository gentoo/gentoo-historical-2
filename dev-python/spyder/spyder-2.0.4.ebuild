# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/spyder/spyder-2.0.4.ebuild,v 1.1 2010/12/13 20:39:30 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython"

inherit distutils eutils

DESCRIPTION="Python IDE with matlab-like features"
HOMEPAGE="http://code.google.com/p/spyderlib/ http://pypi.python.org/pypi/spyder"
SRC_URI="http://spyderlib.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipython matplotlib numpy +pyflakes pylint +rope scipy"

RDEPEND=">=dev-python/PyQt4-4.4[webkit]
	ipython? ( dev-python/ipython )
	matplotlib? ( dev-python/matplotlib )
	numpy? ( dev-python/numpy )
	pyflakes? ( >=dev-python/pyflakes-0.3 )
	pylint? ( dev-python/pylint )
	rope? ( >=dev-python/rope-0.9.0 )
	scipy? ( sci-libs/scipy )"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

PYTHON_MODNAME="spyderlib spyderplugins"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-disable_sphinx_dependency.patch"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		PYTHONPATH="build-$(PYTHON -f --ABI)" sphinx-build doc doc_output || die "Generation of documentation failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		pushd doc_output > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _images _static || die "Installation of documentation failed"
		popd > /dev/null
	fi
}
