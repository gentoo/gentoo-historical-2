# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/runset/runset-1.3-r1.ebuild,v 1.4 2000/09/15 20:08:43 drobbins Exp $

P=runset-1.3
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Runset Init suite, a replacement for sysv style initd"
SRC_URI="ftp://ftp.ocis.net/pub/users/ldeutsch/release/"${A}

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
  try make prefix=${D}/usr install
  prepinfo
  dodoc AUTHORS COPYING INSTALL ChangeLog LSM NEWS README
  cp -a ${S}/sample ${D}/usr/doc/${PF}
 
}





