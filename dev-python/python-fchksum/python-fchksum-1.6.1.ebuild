# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-fchksum/python-fchksum-1.6.1.ebuild,v 1.7 2002/08/02 02:35:00 jnelson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="fchksum is a Python module to find the checksum of files."
SRC_URI="http://www.azstarnet.com/~donut/programs/fchksum/${P}.tar.gz"
HOMEPAGE="http://www.azstarnet.com/~donut/programs/fchksum.html"

DEPEND="sys-libs/zlib"
#RDEPEND=""
KEYWORDS="x86 ppc"
LICENSE="GPL-2"
SLOT="0"

src_compile() {
	python setup.py build || die
}

src_install () {
	python setup.py install --root=${D} || die
}
