# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/guile/guile-1.4-r1.ebuild,v 1.5 2000/10/23 11:27:13 achim Exp $

P=guile-1.4
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Guile is an interpreter for Scheme"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/guile/${A}
	 ftp://prep.ai.mit.edu/gnu/guile/${A}"
HOMEPAGE="http://www.gnu.org/software/guile/"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/usr --with-threads --with-modules
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/usr install
  dodoc AUTHORS COPYING ChangeLog GUILE-VERSION HACKING NEWS README SNAPSHOTS THANKS
}




