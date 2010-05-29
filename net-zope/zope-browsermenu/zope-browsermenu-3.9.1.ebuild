# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope-browsermenu/zope-browsermenu-3.9.1.ebuild,v 1.1 2010/05/29 20:22:11 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Browser menu implementation for Zope."
HOMEPAGE="http://pypi.python.org/pypi/zope.browsermenu"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-zope/zope-browser
	net-zope/zope-component
	net-zope/zope-configuration
	net-zope/zope-i18nmessageid
	net-zope/zope-interface
	net-zope/zope-pagetemplate
	net-zope/zope-publisher
	net-zope/zope-schema
	net-zope/zope-security
	net-zope/zope-traversing"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt README.txt"
PYTHON_MODNAME="${PN/-//}"
