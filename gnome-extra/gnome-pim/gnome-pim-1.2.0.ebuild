# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-pim/gnome-pim-1.2.0.ebuild,v 1.1 2000/08/14 19:44:33 achim Exp $

P=gnome-pim-1.2.0
A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="gnome-office"
DESCRIPTION="gnome-pim"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/gnome-pim/"${A}
HOMEPGAE="http://www.gnome.org/gnome-office/gnome-pim.shtml"
src_compile() {                           
  cd ${S}
  ./configure --host=${CHOST} --prefix=/opt/gnome \
	--with-catgets
  make
}

src_install() {                               
  cd ${S}
  make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog NEWS
  dodoc README*
}



