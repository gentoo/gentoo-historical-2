# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/4Suite/4Suite-0.11.1.ebuild,v 1.2 2002/07/11 06:30:24 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Python tools for XML processing and object-databases."
SRC_URI="ftp://ftp.fourthought.com/pub/4Suite/${P}.tar.gz"
HOMEPAGE="http://www.4suite.org/"

DEPEND="virtual/python
	>=dev-python/PyXML-0.6.5"

src_compile() {
	python setup.py build || die
}

src_install() {
	python setup.py install --prefix=${D}/usr || die
	dodoc COPYRIGHT README* ReleaseNotes
}
