# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-apps/bug-buddy/bug-buddy-1.0.ebuild,v 1.3 2000/09/15 20:08:52 drobbins Exp $

P=bug-buddy-1.0
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="bug-buddy"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/bug-buddy/"${A}
HOMEPAGE="http://www.gnome.org/"

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/opt/gnome --with-catgets 
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* NEWS
  dodoc README* TODO
}



