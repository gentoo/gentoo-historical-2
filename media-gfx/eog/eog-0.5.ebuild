# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/eog/eog-0.5.ebuild,v 1.4 2000/11/04 18:43:06 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Eye of GNOME"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/eog/"${A}
HOMEPAGE="http://www.gnome.org/gnome-office/eog.shtml"

DEPEND=">=gnome-base/bonobo-0.18
	>=gnome-base/gconf-0.8"

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/opt/gnome \
	--with-catgets --with-bonobo
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING DEPENDS ChangeLog HACKING NEWS README TODO MAINTAINERS

}






