# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zconfig/zconfig-2.8.0.ebuild,v 1.2 2010/10/30 18:15:33 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

MY_PN="ZConfig"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Structured Configuration Library"
HOMEPAGE="http://pypi.python.org/pypi/ZConfig"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( net-zope/zope-testing )"
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="${MY_PN}"
DOCS="NEWS.txt README.txt"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-2.7.1-fix_tests.patch"
}

src_install() {
	distutils_src_install

	# Don't install tests.
	rm -fr "${ED}"usr/$(get_libdir)/python*/site-packages/ZConfig/tests
}
