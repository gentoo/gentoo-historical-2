# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/py-xmlrpc/py-xmlrpc-0.8.8.2.ebuild,v 1.5 2002/10/04 05:26:47 vapier Exp $
S=${WORKDIR}/${P}
DESCRIPTION="Fast xml-rpc implementation for Python"
SRC_URI="http://unc.dl.sourceforge.net/sourceforge/py-xmlrpc/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/py-xmlrpc/"
DEPEND="virtual/python"
RDEPEND="$DEPEND"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 sparc sparc64"

src_compile() {
	python setup.py build || die
}

src_install () {
	python setup.py install --prefix=${D}/usr || die
	dodoc CHANGELOG COPYING INSTALL README
	docinto examples
	dodoc examples/*
	docinto examples/crj
	dodoc examples/crj/*
}

