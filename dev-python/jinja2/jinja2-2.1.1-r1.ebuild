# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jinja2/jinja2-2.1.1-r1.ebuild,v 1.2 2009/08/10 20:43:38 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="Jinja2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A small but fast and easy to use stand-alone template engine written in pure python."
HOMEPAGE="http://jinja.pocoo.org/"
SRC_URI="http://pypi.python.org/packages/source/J/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="doc examples i18n test"

CDEPEND="virtual/python
	dev-python/setuptools"
DEPEND="${CDEPEND}
	doc? ( >=dev-python/docutils-0.4
		   >=dev-python/sphinx-0.3 )"
RDEPEND="${CDEPEND}
	i18n? ( >=dev-python/Babel-0.9.3 )"

RESTRICT_PYTHON_ABIS="3*"

S="${WORKDIR}/${MY_P}"
DOCS="CHANGES"

src_prepare(){
	epatch "${FILESDIR}/${PN}-2.0_no_docs.patch"
	epatch "${FILESDIR}/${PN}_docs_sphinx.patch"
}

src_compile(){
	distutils_src_compile

	if use doc ; then
		cd "${S}/docs"
		PYTHONPATH=../ emake html || die "Error building docs"
	fi
}

src_test(){
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" setup.py test
	}
	python_execute_function testing
}

src_install(){
	distutils_src_install

	if use doc ; then
		dohtml -r docs/_build/html/* ||
			die "Failed to install docs"
	fi

	if use examples ; then
		#Eliminate pyc files going into /usr/share
	    $(find examples -name '*.pyc' -exec rm -rf {} ';')

		insinto "/usr/share/doc/${PF}"
		doins -r examples ||
			die "Failed to install examples"
	fi
}
