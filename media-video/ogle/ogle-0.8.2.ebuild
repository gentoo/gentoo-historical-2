# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bruce A. Locke
# $Header: /var/cvsroot/gentoo-x86/media-video/ogle/ogle-0.8.2.ebuild,v 1.1 2002/01/17 20:59:24 blocke Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Ogle is a full featured DVD player that supports DVD menus"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${P}.tar.gz"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"

DEPEND="media-libs/libdvdcss media-libs/jpeg dev-libs/libxml2 media-libs/libdvdread media-libs/a52dec x11-base/xfree"

src_compile() {

  local myconf

  use mmx || myconf="--disable-mmx"
  use oss || myconf="${myconf} --disable-oss"

  ./configure --prefix=/usr --sysconfdir=/etc --host=${CHOST}  || die
  make CFLAGS="${CFLAGS} -I/usr/include/libxml2/libxml -I/usr/include/libxml2" || die	

}

src_install() {
	
  make prefix=${D}/usr mandir=${D}/usr/share/man infodir=${D}/usr/share/info docdir=${D}/usr/share/doc/${PF}/html sysconfdir=${D}/etc install || die

  dodoc AUTHORS COPYING ChangeLog HISTORY INSTALL NEWS README TODO doc/liba52.txt

}

