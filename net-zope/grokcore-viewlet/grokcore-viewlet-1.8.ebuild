# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/grokcore-viewlet/grokcore-viewlet-1.8.ebuild,v 1.1 2010/12/19 18:23:38 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Grok-like configuration for zope viewlets"
HOMEPAGE="http://grok.zope.org/ http://pypi.python.org/pypi/grokcore.viewlet"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-python/martian-0.13
	>=net-zope/grokcore-component-2.1
	>=net-zope/grokcore-security-1.5
	>=net-zope/grokcore-view-2.2
	net-zope/zope-browserpage
	net-zope/zope-component
	net-zope/zope-contentprovider
	net-zope/zope-interface
	net-zope/zope-publisher
	net-zope/zope-security
	net-zope/zope-viewlet"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt README.txt"
PYTHON_MODNAME="${PN/-//}"
