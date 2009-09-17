# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycairo/pycairo-1.8.8.ebuild,v 1.5 2009/09/17 10:54:35 arfrever Exp $

EAPI="2"

NEED_PYTHON="2.6"
SUPPORT_PYTHON_ABIS="1"

inherit distutils multilib

DESCRIPTION="Python wrapper for cairo vector graphics library"
HOMEPAGE="http://cairographics.org/pycairo/"
SRC_URI="http://cairographics.org/releases/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples svg"

RDEPEND=">=x11-libs/cairo-1.8.8[svg=]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-python/sphinx-0.6 )"

RESTRICT_PYTHON_ABIS="2.4 2.5 3*"

PYTHON_MODNAME="cairo"
DOCS="AUTHORS NEWS README"

src_prepare() {
	# Don't run py-compile.
	sed -i \
		-e '/if test -n "$$dlist"; then/,/else :; fi/d' \
		src/Makefile.in || die "sed in src/Makefile.in failed"

	epatch "${FILESDIR}/${P}-pkgconfig_dir.patch"
}

src_configure() {
	if use doc; then
		econf
	fi
}

src_compile() {
	distutils_src_compile

	if use doc; then
		emake html || die "emake html failed"
	fi
}

src_test() {
	testing() {
		pushd test > /dev/null
		PYTHONPATH="$(ls -d ../build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" -c "import examples_test; examples_test.test_examples(); examples_test.test_snippets_png()" || return 1
		popd > /dev/null
	}
	python_execute_function testing
}

src_install() {
	PKGCONFIG_DIR="/usr/$(get_libdir)/pkgconfig" distutils_src_install

	if use doc; then
		dohtml -r doc/.build/html/ || die "dohtml -r doc/.build/html/ failed"
	fi

	if use examples; then
		# Delete files created by tests.
		find examples{,/cairo_snippets/snippets} -maxdepth 1 -name "*.png" | xargs rm -f

		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
		rm "${D}"/usr/share/doc/${PF}/examples/Makefile*
	fi

	# dev-python/pycairo-1.8.8 doesn't install __init__.py automatically.
	# http://lists.cairographics.org/archives/cairo/2009-August/018044.html
	installation() {
		insinto "$(python_get_sitedir)/cairo"
		doins src/__init__.py
	}
	python_execute_function -q installation
}
