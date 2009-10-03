# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipy/ipy-0.64.ebuild,v 1.1 2009/10/03 22:18:27 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="IPy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A python Module for handling IP-Addresses and Networks"
HOMEPAGE="http://software.inl.fr/trac/trac.cgi/wiki/IPy http://pypi.python.org/pypi/IPy"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_IPy.py
	}
	python_execute_function testing
}

pkg_postinst() {
	python_mod_optimize IPy.py
}

pkg_postrm() {
	python_mod_cleanup
}
