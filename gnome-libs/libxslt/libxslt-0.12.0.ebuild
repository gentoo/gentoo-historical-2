# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-libs/libxslt/libxslt-0.12.0.ebuild,v 1.1 2001/06/18 15:22:39 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libxslt"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/${PN}/${A}
         ftp://gnome.eazel.com/pub/gnome/unstable/sources/${PN}/${A}"

HOMEPAGE="http://www.gnome.org/"

DEPEND="virtual/glibc sys-devel/perl
	>=gnome-libs/libxml2-2.3.9"

RDEPEND="virtual/glibc
	>=gnome-libs/libxml2-2.3.9"

src_compile() {

  try ./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man
  try make
}

src_install() {                               

        try make prefix=${D}/usr mandir=${D}/usr/share/man  install
	dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
}

