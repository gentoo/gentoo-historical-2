# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/py-xmlrpc/py-xmlrpc-0.8.7.ebuild,v 1.3 2002/07/11 06:30:24 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Fast xml-rpc implementation for Python"
SRC_URI="mirror://sourceforge/py-xmlrpc/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/py-xmlrpc/"

DEPEND="virtual/python"
RDEPEND="$DEPEND"

src_compile() {
	python setup.py build || die
}

src_install () {
	python setup.py install --prefix=${D}/usr || die
	dodoc CHANGELOG COPYING INSTALL README
	dodoc doc/*
	docinto example
	dodoc doc/example/*
}
