# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/oaf/oaf-0.3.0.ebuild,v 1.2 2000/08/16 04:38:03 drobbins Exp $

P=oaf-0.3.0
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Object Activation Framework for GNOME"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/oaf/"${A}

src_compile() {                           
  cd ${S}
  ./configure --host=${CHOST} --prefix=/opt/gnome
  make
}

src_install() {                               
  cd ${S}
  make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog README
  dodoc NEWS
}




