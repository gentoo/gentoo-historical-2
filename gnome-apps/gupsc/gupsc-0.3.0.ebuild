# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-apps/gupsc/gupsc-0.3.0.ebuild,v 1.3 2000/09/15 20:08:54 drobbins Exp $

P=gupsc-0.3.0
A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="A Gnome client for the Network UPS Tools (nut)"
SRC_URI="http://www.stud.ifi.uio.no/~hennikul/gupsc/download/"${A}
HOMEPAGE="http://www.stud.ifi.uio.no/~hennikul/gupsc/"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/opt/gnome --with-catgets
  try make
}

src_install() {                               
  cd ${S}
  try make DESTDIR=${D} install
  dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}



