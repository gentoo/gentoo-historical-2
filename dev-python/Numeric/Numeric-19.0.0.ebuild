# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/Numeric/Numeric-19.0.0.ebuild,v 1.12 2002/10/20 18:47:32 vapier Exp $


S=${WORKDIR}/${P}
DESCRIPTION="numerical python module"
SRC_URI="mirror://sourceforge/numpy/${P}.tar.gz"
HOMEPAGE="http://www.pfdubois.com/numpy/"

DEPEND="virtual/python"

SLOT="0"
KEYWORDS="x86 ppc sparc sparc64 alpha"
LICENSE="as-is"

PYTHON_VERSION=

src_compile() {
	python setup_all.py build || die
}

src_install() {
	python setup_all.py install --prefix=${D}/usr  || die

	dodoc MANIFEST PKG-INFO README*

	#need to automate the python version in the path
	mv Demo/NumTut ${D}/usr/lib/python2.0/site-packages/
}
