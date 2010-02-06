# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pastescript/pastescript-1.7.3.ebuild,v 1.4 2010/02/06 15:40:07 arfrever Exp $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="PasteScript"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A pluggable command-line frontend, including commands to setup package file layouts"
HOMEPAGE="http://pythonpaste.org/script/ http://pypi.python.org/pypi/PasteScript"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc"
#IUSE="doc test"

RDEPEND="dev-python/paste
	dev-python/pastedeploy
	dev-python/cheetah"
DEPEND="${RDEPEND}
	dev-python/setuptools
	doc? ( dev-python/buildutils dev-python/pygments dev-python/pudge )"
#	test? ( dev-python/nose )
RESTRICT_PYTHON_ABIS="3.*"

# Tests are broken.
RESTRICT="test"

S="${WORKDIR}/${MY_P}"
PYTHON_MODNAME="paste/script"

src_compile() {
	distutils_src_compile
	if use doc; then
		einfo "Generating docs as requested..."
		PYTHONPATH=. "$(PYTHON -f)" setup.py pudge || die "generating docs failed"
	fi
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" nosetests-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	use doc && dohtml -r docs/html/*
}
