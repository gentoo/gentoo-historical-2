# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/ggv/ggv-0.95.ebuild,v 1.1 2000/08/15 15:27:06 achim Exp $

P=ggv-0.95
A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="gnome-apps"
DESCRIPTION="Gnome Ghostview"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/ggv/"${A}
HOMEPAGE="http://www.gnome.org/"


src_compile() {                           
  cd ${S}
  cp configure configure.orig
  sed -e "s/BONOBO_TRUE/BONOBO_FALSE/" configure.orig > configure
  ./configure --host=${CHOST} --prefix=/opt/gnome \
	--with-catgets --without-bonobo
  make
}

src_install() {                               
  cd ${S}
  make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING ChangeLog NEWS README TODO

}



