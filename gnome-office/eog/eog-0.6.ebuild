# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-office/eog/eog-0.6.ebuild,v 1.1 2001/04/29 15:28:08 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Eye of GNOME"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/eog/"${A}
HOMEPAGE="http://www.gnome.org/gnome-office/eog.shtml"

DEPEND=">=gnome-base/bonobo-0.18
	>=gnome-base/gconf-0.8"

src_compile() {                           
  try ./configure --host=${CHOST} --prefix=/opt/gnome \
	--with-bonobo
  try make
}

src_install() {                               
  try make prefix=${D}/opt/gnome \
	GCONG_CONFIG_SOURCE=xml=${D}/opt/gnome/etc/gconf/gconf.xml.defaults install
  dodoc AUTHORS COPYING DEPENDS ChangeLog HACKING NEWS README TODO MAINTAINERS

}







