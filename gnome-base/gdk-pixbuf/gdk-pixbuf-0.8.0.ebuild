# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gdk-pixbuf/gdk-pixbuf-0.8.0.ebuild,v 1.1 2000/08/14 15:42:03 achim Exp $

P=gdk-pixbuf-0.8.0
A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="gnome-base"
DESCRIPTION="GNOME Image Library"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/gdk-pixbuf"${A}


src_compile() {                           
  cd ${S}
  ./configure --host=${CHOST} --prefix=/opt/gnome 
  make
}

src_install() {                               
  cd ${S}
  make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog INSTALL README NEWS TODO
}



