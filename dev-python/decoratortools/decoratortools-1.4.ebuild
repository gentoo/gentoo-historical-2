# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/decoratortools/decoratortools-1.4.ebuild,v 1.2 2007/05/03 04:51:49 pythonhead Exp $

inherit distutils

MY_PN="DecoratorTools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Use class and function decorators - even in Python 2.3 - now with source debugging for generated code"
HOMEPAGE="http://cheeseshop.python.org/pypi/DecoratorTools"
SRC_URI="http://cheeseshop.python.org/packages/source/D/DecoratorTools/${MY_P}.zip"
LICENSE="|| ( PSF-2.4 ZPL )"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

S=${WORKDIR}/${MY_P}

src_test() {
	${python} setup.py test
}
