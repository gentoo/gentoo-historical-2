# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/bug-buddy/bug-buddy-2.0.5.ebuild,v 1.1 2001/07/29 10:43:55 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="bug-buddy"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${A}"
HOMEPAGE="http://www.gnome.org/"

DEPEND="virtual/glibc nls? ( sys-devel/gettext )
        >=gnome-base/gnome-vfs-1.0.1
        >=gnome-base/libglade-0.15
        >=media-libs/gdk-pixbuf-0.11.0
	gnome-base/libxml"

RDEPEND="virtual/glibc
        >=gnome-base/gnome-vfs-1.0.1
        >=gnome-base/libglade-0.15
        >=media-libs/gdk-pixbuf-0.11.0
	gnome-base/libxml"

src_compile() {
  local myconf
  if [ -z "`use nls`" ] ; then
    myconf="--disbale-nls"
  fi
  try ./configure --host=${CHOST} --prefix=/opt/gnome  $myconf
  try make
}

src_install() {
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* NEWS
  dodoc README* TODO
}





