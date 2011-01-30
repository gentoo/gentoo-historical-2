# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/envisagecore/envisagecore-3.2.0.ebuild,v 1.1 2011/01/30 17:56:45 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils virtualx

MY_PN="EnvisageCore"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enthought Tool Suite: Extensible application framework"
HOMEPAGE="http://code.enthought.com/projects/envisage/ http://pypi.python.org/pypi/EnvisageCore"
SRC_URI="http://www.enthought.com/repo/ETS/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND=">=dev-python/apptools-3.4.1
	>=dev-python/enthoughtbase-3.1.0
	>=dev-python/traits-3.6.0"
DEPEND="${RDEPEND}
	dev-python/setuptools
	doc? ( dev-python/sphinx )
	test? (
		dev-python/coverage
		dev-python/nose
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		x11-apps/xhost
	)"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="enthought"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html || die "Generation of documentation failed"
		popd > /dev/null
	fi
}

src_test() {
	maketype="distutils_src_test" virtualmake
}

src_install() {
	distutils_src_install

	if use doc; then
		pushd docs/build/html > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static || die "Installation of documentation failed"
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die "Installation of examples failed"
	fi
}
