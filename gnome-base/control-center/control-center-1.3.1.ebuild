# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/control-center/control-center-1.3.1.ebuild,v 1.3 2000/12/03 20:15:43 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The GNOME control-center"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/${PN}/"${A}
HOMEPAGE="http://www.gnome.org/"


src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/opt/gnome 
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog README NEWS
}





