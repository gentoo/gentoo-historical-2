# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgtop/libgtop-1.0.10.ebuild,v 1.1 2000/11/25 12:57:02 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libgtop"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/"${A}
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=gnome-base/gnome-libs-1.2.8"

src_compile() {                           
  cd ${S}
  #LDFLAGS="-lncurses"
  try ./configure --host=${CHOST} --prefix=/opt/gnome
  try make
}

src_install() {
  cd ${S}
  try make prefix=${D}/opt/gnome install
  dodoc ABOUT-NLS AUTHORS COPYING* ChangeLog INSTALL LIBGTOP* README NEWS
  dodoc RELNOTES*
  doinfo doc/libgtop.info

}



