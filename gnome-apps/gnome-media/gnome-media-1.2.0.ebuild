# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-apps/gnome-media/gnome-media-1.2.0.ebuild,v 1.4 2000/11/03 17:47:45 achim Exp $

P=gnome-media-1.2.0
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="gnome-media"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/gnome-media/"${A}
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=gnome-base/gnome-libs-1.2.4
	>=gnome-base/libghttp-1.0.7"

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/opt/gnome \
	--with-catgets --with-ncurses
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog NEWS
  dodoc README*
}



