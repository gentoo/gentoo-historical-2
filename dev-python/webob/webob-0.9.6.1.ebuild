# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/webob/webob-0.9.6.1.ebuild,v 1.3 2009/11/27 22:26:18 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="WebOb"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="WSGI request and response object"
HOMEPAGE="http://pythonpaste.org/webob/ http://pypi.python.org/pypi/WebOb"
SRC_URI="http://pypi.python.org/packages/source/W/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

#Note: Tests require webtest, but webob is a dependency of webtest.
DEPEND="dev-python/setuptools"
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"
