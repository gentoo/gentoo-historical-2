# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmikmod/libmikmod-3.1.9-r1.ebuild,v 1.3 2000/09/15 20:09:02 drobbins Exp $

P=libmikmod-3.1.9
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The boldest sound on the planet"
SRC_URI="http://mikmod.darkorb.net/libmikmod/"${A}

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/usr
  try make
}

src_install() {                               
  cd ${S}
  try make DESTDIR=${D} install
  prepman
  prepinfo
  dodoc AUTHORS COPYING* NEWS PROBLEMS README TODO *.lsm
  docinto html
  dodoc docs/*.html
}




