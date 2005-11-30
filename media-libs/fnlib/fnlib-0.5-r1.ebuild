# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/fnlib/fnlib-0.5-r1.ebuild,v 1.1 2001/10/06 15:30:16 danarmak Exp $

P=fnlib-0.5
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Font Library"
SRC_URI="ftp://ftp.enlightenment.org/pub/enlightenment/enlightenment/libs/"${A}

DEPEND="virtual/glibc >=media-libs/imlib-1.9.8.1"

src_compile() {

  try ./configure --host=${CHOST} --prefix=/usr --sysconfdir=/etc/fnlib
  try make
}

src_install() {
  
  try make prefix=${D}/usr sysconfdir=${D}/etc/fnlib install
  dodoc AUTHORS ChangeLog COPYING* HACKING NEWS README
  dodoc doc/fontinfo.README

}




