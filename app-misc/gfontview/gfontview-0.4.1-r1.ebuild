# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-misc/gfontview/gfontview-0.4.1-r1.ebuild,v 1.1 2000/08/07 11:55:08 achim Exp $

P=gfontview-0.4.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="app-misc"
DESCRIPTION="Fontviewer for PostScript Tpe 1 and TrueType"
SRC_URI="http://download.sourceforge.net/gfontview/"${A}
HOMEPAGE="http://gfontview.sourceforge.net"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  CPPFLAGS="$CFLAGS -I/usr/include/freetype" ./configure --host=${CHOST} --prefix=/usr/X11R6 --with-catgets
  make
}

src_install() {                               
  cd ${S}
  make prefix=${D}/usr/X11R6 install
  dodoc AUTHORS COPYING ChangeLog NEWS README TODO
  insinto /usr/X11R6/include/X11/pixmaps/
  doins error.xpm openhand.xpm font.xpm t1.xpm tt.xpm 
}



