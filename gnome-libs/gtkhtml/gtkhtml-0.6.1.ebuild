# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-libs/gtkhtml/gtkhtml-0.6.1.ebuild,v 1.2 2000/08/16 04:38:03 drobbins Exp $

P=gtkhtml-0.6.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="gtkhtml"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/gtkhtml/"${A}
HOMEPAGE="http://www.gnome.org/"

src_compile() {                           
  cd ${S}
  ./configure --host=${CHOST} --prefix=/opt/gnome --with-bonobo
  make
}

src_install() {                               
  cd ${S}
  make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog README
  dodoc NEWS TODO
}





