# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/ORBit/ORBit-0.5.3.ebuild,v 1.4 2000/10/14 11:38:33 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A high-performance, lightweight CORBA ORB aiming for CORBA 2.2 compliance"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/"${A}
HOMEPAGE="http://www.labs.redhat.com/orbit/"

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/opt/gnome
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
  prepinfo /opt/gnome

  dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
  dodoc docs/*.txt docs/IDEA1
  docinto idl
  cd libIDL
  dodoc AUTHORS BUGS COPYING NEWS README*
  docinto popt
  cd ../popt
  dodoc CHANGES COPYING README
}



