# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychecker/pychecker-0.8.3.ebuild,v 1.8 2002/10/04 05:26:54 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="PyChecker is a tool for finding common bugs in python source code."
SRC_URI="mirror://sourceforge/pychecker/${P}.tar.gz"
HOMEPAGE="http://pychecker.sourceforge.net/"

DEPEND="virtual/python"
RDEPEND="${DEPEND}"

SLOT="0"
KEYWORDS="x86 sparc sparc64"
LICENSE="BSD"

src_install(){
	python setup.py install --prefix=${D}/usr || die
	dodoc CHANGELOG COPYRIGHT KNOWN_BUGS MAINTAINERS
	dodoc README TODO VERSION
}
