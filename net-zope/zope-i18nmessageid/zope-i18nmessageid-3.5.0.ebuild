# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope-i18nmessageid/zope-i18nmessageid-3.5.0.ebuild,v 1.1 2009/10/24 21:28:42 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Message Identifiers for internationalization"
HOMEPAGE="http://pypi.python.org/pypi/zope.i18nmessageid"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="${PN/-//}"
DOCS="CHANGES.txt README.txt"

src_install() {
	distutils_src_install

	# Don't install C sources.
	find "${D}" -name "*.c" | xargs rm -f
}
