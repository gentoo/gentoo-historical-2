# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/medusa/medusa-0.5.1.ebuild,v 1.3 2001/06/11 08:11:28 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="medusa"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${A}
         ftp://gnome.eazel.com/pub/gnome/stable/sources/${PN}/${A}"
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=gnome-base/gnome-vfs-1.0"

src_compile() {
  try ./configure --host=${CHOST} --prefix=/opt/gnome \
        --sysconfdir=/etc/opt/gnome --mandir=/opt/gnome/man \
        --sharedstatedir=/var/lib --localstatedir=/var/lib --enable-prefere-db1
  try pmake medusainitdir=/tmp
}

src_install() {
  try make prefix=${D}/opt/gnome sysconfdir=${D}/etc/opt/gnome \
        medusainitdir=/tmp mandir=${D}/opt/gnome/man install
  dodoc AUTHORS COPYING ChangeLog NEWS README

}







