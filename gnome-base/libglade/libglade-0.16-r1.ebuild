# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libglade/libglade-0.16-r1.ebuild,v 1.2 2001/06/05 19:43:20 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libglade"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${A}
         ftp://gnome.eazel.com/pub/gnome/stable/sources/${PN}/${A}"
HOMEPAGE="http://www.gnome.org/"

DEPEND="nls? ( sys-devel/gettext )
        >=gnome-base/gnome-libs-1.2.12
	>=gnome-base/libxml-1.8.11
	bonobo2? ( >=gnome-base/bonobo-0.37 )"

src_compile() {

  local myopts
  if [ "`use bonobo2`" ]
  then
     # I had to add --disable-bonobotest, because, for some reason,
     # the conftest in configure segfaults, but libglade still
     # compiles and runs just fine... -- pete
     myconf="--enable-bonobo --disable-bonobotest"
  else
     myconf="--disable-bonobo"
  fi
  if [ -z "`use nls`" ]
  then
    myconf="${myconf} --disable-nls"
  fi
  try ./configure --host=${CHOST} --prefix=/opt/gnome ${myconf}
  try make

}

src_install() {
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog NEWS
  dodoc doc/*.txt
}









