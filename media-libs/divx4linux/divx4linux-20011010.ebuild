# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Martin Schlemmer <azarah@gentoo.org>

S="${WORKDIR}/divx4linux-${PV}"
DESCRIPTION="Binary release of DivX Codec 4.0"
SRC_URI="http://download3.divx.com/videocodecs/linux/divx4linux-${PV}_4.02.tgz"
HOMEPAGE="http://www.divx.com/"

DEPEND="virtual/glibc"


src_install () {
	
	dodir /usr/{lib,include}

	dolib.so *.so

	insinto /usr/include
	doins *.h

	dodoc RELNOTES.linux license.txt
	cp -a 'Codec Core Interface.txt' ${D}/usr/share/doc/${P}/ 
}

