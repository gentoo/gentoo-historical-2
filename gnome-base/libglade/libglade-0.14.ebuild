# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libglade/libglade-0.14.ebuild,v 1.3 2000/09/15 20:08:56 drobbins Exp $

P=libglade-0.14
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libglade"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/libglade/"${A}
HOMEPAGE="http://www.gnome.org/"

src_unpack() {
  unpack ${A}
  cd ${S}
  # Bonobo does not work at the moment
  cp configure.in configure.in.orig
  sed -e "s:have_bonobo=true:have_bonobo=false:" configure.in.orig > configure.in
  autoconf configure.in > configure
}
src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/opt/gnome --with-catgets
  try make 
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog NEWS
  dodoc doc/*.txt
}





