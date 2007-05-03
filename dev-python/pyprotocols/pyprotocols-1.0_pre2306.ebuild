# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyprotocols/pyprotocols-1.0_pre2306.ebuild,v 1.1 2007/05/03 04:38:35 pythonhead Exp $

NEED_PYTHON=2.4

inherit distutils

KEYWORDS="~x86"

MY_PN=PyProtocols
MY_P=${MY_PN}-${PV/_pre/a0dev_r}

DESCRIPTION="Extends the PEP 246 adapt() function with a new 'declaration API' that lets you easily define your own protocols and adapters, and declare what adapters should be used to adapt what types, objects, or protocols."
HOMEPAGE="http://peak.telecommunity.com/PyProtocols.html"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
LICENSE="|| ( PSF-2.4 ZPL )"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools
	app-arch/unzip
	>=dev-python/decoratortools-1.4"
RDEPEND=""

S=${WORKDIR}/${MY_PN}

PYTHON_MODNAME="protocols"

