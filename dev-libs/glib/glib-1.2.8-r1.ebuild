# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/glib/glib-1.2.8-r1.ebuild,v 1.4 2000/10/23 11:27:13 achim Exp $

# also, this script now has pre/post inst/rm support

P=glib-1.2.8
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The GLib library of C routines"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v1.2/"${A}
HOMEPAGE="http://www.gtk.org/"

src_compile() {
  cd ${S}                           
  try ./configure --host=${CHOST} --prefix=/usr --with-threads=posix
  try make
}

src_install() {
  cd ${S}
  try make install prefix=${D}/usr
  dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS
  cd docs
  docinto html
  dodoc glib.html glib_toc.html
}





