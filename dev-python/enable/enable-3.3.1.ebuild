# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/enable/enable-3.3.1.ebuild,v 1.1 2010/07/07 04:46:49 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils virtualx

MY_PN="Enable"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enthought Tool Suite drawing and interaction GUI objects"
HOMEPAGE="http://code.enthought.com/projects/enable http://pypi.python.org/pypi/Enable"
SRC_URI="http://www.enthought.com/repo/ETS/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="dev-python/numpy
	dev-python/reportlab
	>=dev-python/traitsgui-3.4.0
	>=media-libs/freetype-2
	virtual/glu
	x11-libs/libX11"

DEPEND="dev-python/setuptools
	dev-python/numpy
	>=media-libs/freetype-2
	virtual/glu
	x11-libs/libX11
	dev-lang/swig
	dev-python/pyrex
	doc? ( dev-python/setupdocs )
	test? ( >=dev-python/nose-0.10.3
			>=dev-python/enthoughtbase-3.0.5
			>=dev-python/traitsgui-3.4.0[wxwidgets] )"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_MODNAME="enthought"

src_prepare() {
	# "${S}/enthought/enable2/tests" does not exist.
	sed -e "s:,enthought/enable2/tests::" -i setup.cfg || die "sed setup.cfg failed"

	sed \
		-e "s/self.run_command('build_docs')/pass/" \
		-e "/setupdocs>=1.0/d" \
		-i setup.py || die "sed setup.py failed"

	epatch "${FILESDIR}/${PN}-3.3.0-nofreetype.patch"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		"$(PYTHON -f)" setup.py build_docs --formats=html,pdf || die "Generation of documentation failed"
	fi
}

src_test() {
	maketype="distutils_src_test" virtualmake
}

src_install() {
	find "${S}" -name "*LICENSE.txt" -delete
	distutils_src_install
	dodoc docs/*.txt
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins -r build/docs/html || die
		doins build/docs/latex/*.pdf || die
	fi
	if use examples; then
		doins -r examples || die
	fi
}
