# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ollie Rutherfurd <oliver@rutherfurd.net>
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychecker/pychecker-0.8.3.ebuild,v 1.3 2001/12/07 21:26:17 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="PyChecker is a tool for finding common bugs in python source code."
SRC_URI="http://prdownloads.sourceforge.net/pychecker/${P}.tar.gz"
HOMEPAGE="http://pychecker.sourceforge.net/"

DEPEND="virtual/python"

src_install(){
	python setup.py install --prefix=${D}/usr || die
	dodoc CHANGELOG COPYRIGHT KNOWN_BUGS MAINTAINERS
	dodoc README TODO VERSION
}
