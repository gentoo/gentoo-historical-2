# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmp/gmp-3.1.ebuild,v 1.2 2000/09/15 20:08:48 drobbins Exp $

P=gmp-3.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Library for arithmetic on arbitrary precision integers, rational numbers, and floating-point numbers"
SRC_URI="ftp://prep.ai.mit.edu/gnu/gmp/"${A}
HOMEPAGE="http://www.gnu.org/software/gmp/gmp.html"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  try ./configure --prefix=/usr
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/usr install
  prepinfo 
  dodoc AUTHORS ChangeLog COPYING* NEWS README
  docinto html
  dodoc projects/*.html
}





