# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sympy/sympy-0.6.2.ebuild,v 1.2 2008/10/25 13:20:22 pvdabeel Exp $

NEED_PYTHON=2.4
inherit distutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples gtk imaging ipython latex mathml opengl pdf png test texmacs"

RDEPEND="mathml? ( dev-libs/libxml2
		dev-libs/libxslt
		gtk? ( x11-libs/gtkmathview ) )
	latex? ( virtual/latex-base
		png? ( app-text/dvipng )
		pdf? ( virtual/ghostscript ) )
	texmacs? ( app-office/texmacs )
	ipython? ( dev-python/ipython )
	opengl? ( dev-python/pyopengl )
	imaging? ( dev-python/imaging )
	|| ( dev-python/ctypes >=dev-lang/python-2.5 )
	>=dev-python/pexpect-2.0"
DEPEND="doc? ( dev-python/sphinx )
	test? ( >=dev-python/py-0.9.0 )"

pkg_setup() {
	if use mathml; then
		if ! built_with_use dev-libs/libxml2 python; then
			eerror "dev-libs/libxml2 has to be compiled with 'python' USE-flag."
			die "Needed USE-flag for dev-libs/libxml2 not found."
		fi

		if ! built_with_use dev-libs/libxslt python; then
			eerror "dev-libs/libxslt has to be compiled with 'python' USE-flag."
			die "Needed USE-flag for dev-libs/libxslt not found."
		fi

		if use gtk && ! built_with_use x11-libs/gtkmathview gtk; then
			eerror "x11-libs/gtkmathview has to be compiled with 'gtk' USE-flag."
			die "Needed USE-flag for x11-libs/gtkmathview not found."
		fi
	fi
}

src_unpack() {
	distutils_src_unpack

	# use local sphinx
	epatch "${FILESDIR}"/${P}-sphinx.patch
}

src_compile() {
	distutils_src_compile

	if use doc; then
		cd doc
		PYTHONPATH=.. emake SPHINXBUILD=sphinx-build html \
			|| die "emake html failed"
		cd ..
	fi
}

src_test() {
	PYTHONPATH=build/lib/ "${python}" setup.py test || die "Unit tests failed!"
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/_build/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${P}
	    doins -r examples
	fi

	if use texmacs; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}
