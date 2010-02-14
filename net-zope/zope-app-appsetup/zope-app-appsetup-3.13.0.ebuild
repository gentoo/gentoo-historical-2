# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope-app-appsetup/zope-app-appsetup-3.13.0.ebuild,v 1.4 2010/02/14 19:17:21 armin76 Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Zope app setup helper"
HOMEPAGE="http://pypi.python.org/pypi/zope.app.appsetup"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-zope/zodb
	net-zope/zope-app-publication
	net-zope/zope-component
	net-zope/zope-configuration
	net-zope/zope-container
	net-zope/zope-error
	net-zope/zope-event
	net-zope/zope-interface
	net-zope/zope-lifecycleevent
	net-zope/zope-processlifetime
	net-zope/zope-security
	net-zope/zope-session
	net-zope/zope-site
	net-zope/zope-testing
	net-zope/zope-traversing"
DEPEND="${RDEPEND}
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="${PN//-//}"
DOCS="CHANGES.txt README.txt"
