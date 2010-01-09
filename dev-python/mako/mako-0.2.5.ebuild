# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mako/mako-0.2.5.ebuild,v 1.7 2010/01/09 20:47:13 armin76 Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="Mako-${PV}"

DESCRIPTION="A python templating language."
HOMEPAGE="http://www.makotemplates.org/ http://pypi.python.org/pypi/Mako"
SRC_URI="http://www.makotemplates.org/downloads/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc test"

RDEPEND=""
DEPEND="dev-python/setuptools
	test? ( dev-python/beaker )"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="lib:build-${PYTHON_ABI}/lib" "$(PYTHON)" test/alltests.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	use doc && dohtml doc/*html doc/*css
}
