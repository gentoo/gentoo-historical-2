# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Tod M. Neidt <tneidt@fidnet.com>
# /home/cvsroot/gentoo-x86/dev-python/scientific--python/ScientificPython-2.2.ebuild,v 1.4 2001/06/04 21:57:52 achim Exp
# $Header: /var/cvsroot/gentoo-x86/dev-python/ScientificPython/ScientificPython-2.2.ebuild,v 1.4 2001/11/10 12:14:29 hallski Exp $


S=${WORKDIR}/${P}
DESCRIPTION="scientific python module"
SRC_URI="http://starship.python.net/crew/hinsen/${P}.tar.gz"
HOMEPAGE="http://starship.python.net/crew/hinsen/scientific.html"

DEPEND=">=dev-lang/python-2.0-r4
        >=dev-python/Numeric-19.0
        >=app-misc/netcdf-3.0"
	
src_compile() {
	python setup.py build || die
}

src_install() {
	python setup.py install --prefix=${D}/usr || die
	dodoc MANIFEST.in COPYRIGHT README*
}
