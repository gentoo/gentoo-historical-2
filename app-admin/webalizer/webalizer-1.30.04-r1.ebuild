# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/webalizer/webalizer-1.30.04-r1.ebuild,v 1.3 2000/11/02 02:17:12 achim Exp $

P=webalizer-1.30-04
A=${P}-src.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="Webalizer"
SRC_URI="ftp://ftp.mrunix.net/pub/webalizer/"${A}
HOMEPAGE="http://www.mrunix.net/webalizer/"

DEPEND=">=sys-libs/glibc-2.1.3
	>=media-libs/libgd-1.8.3
	>=media-libs/libpng-1.0.8"

src_unpack() {
  unpack ${A}
  cd ${S}
  cp graphs.c graphs.c.orig
  sed -e "s/gdImageGif.*/gdImagePng(im,out);/g" graphs.c.orig >graphs.c
  cp webalizer.c webalizer.c.orig
  sed -e "s/\.gif/\.png/g" webalizer.c.orig > webalizer.c

}

src_compile() {                           
  cd ${S}
  LDFLAGS="-lpng" try ./configure --host=${CHOST} --prefix=/usr
  try make
}

src_install() {                               
  cd ${S}
  into /usr
  dobin webalizer
  doman webalizer.1
  insinto /etc/httpd
  cp sample.conf webalizer.conf
  doins webalizer.conf
  dodoc README* CHANGES COPYING Copyright
}





