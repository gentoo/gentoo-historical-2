# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ollie Rutherfurd <oliver@rutherfurd.net>
# $Header $

S=${WORKDIR}/${P}
DESCRIPTION="A collection of libraries to process XML with Python."
SRC_URI="http://prdownloads.sourceforge.net/pyxml/${P}.tar.gz"
HOMEPAGE="http://pyxml.sourceforge.net/"

DEPEND="virtual/python"

src_compile() {
	python setup.py build || die
}

src_install() {
	python setup.py install --prefix=${D}/usr || die

	dodoc MANIFEST README *
}


