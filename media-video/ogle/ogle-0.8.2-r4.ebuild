# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bruce A. Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/ogle/ogle-0.8.2-r4.ebuild,v 1.1 2002/03/25 21:18:35 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Ogle is a full featured DVD player that supports DVD menus"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${P}.tar.gz"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"

DEPEND="media-libs/libdvdcss media-libs/jpeg dev-libs/libxml2 media-libs/libdvdread media-libs/a52dec x11-base/xfree"

src_compile() {
	# Fix libxml2. note, this is CLUDGE and not good!
 	CFLAGS="${CFLAGS} -I/usr/include/libxml2/libxml" 
	CXXFLAGS="${CXXFLAGS} -I/usr/include/libxml2/libxml"
	local myconf
	
	use mmx || myconf="--disable-mmx"
	use oss || myconf="${myconf} --disable-oss"
	libtoolize --copy --force
	./configure --prefix=/usr --enable-shared --sysconfdir=/etc --host=${CHOST}  || die
	make CFLAGS="${CFLAGS} -I/usr/include/libxml2/libxml -I/usr/include/libxml2" || die	

}

src_install() {
	
  make prefix=${D}/usr mandir=${D}/usr/share/man infodir=${D}/usr/share/info docdir=${D}/usr/share/doc/${PF}/html sysconfdir=${D}/etc install || die
  dodoc AUTHORS COPYING ChangeLog HISTORY INSTALL NEWS README TODO doc/liba52.txt

  # fix bug #376: ogle build does not install libdvdcontrol shared libs
  # if libs are not already installed... (could not find error in makefile)
  insinto /usr/lib/ogle
  doins ogle/.libs/libdvdcontrol.a
  mv ogle/libdvdcontrol.la ogle/libdvdcontrol.la.old
  sed 's|/var/tmp/portage/ogle-0.8.2-r2/work/ogle-0.8.2/ogle|/usr/lib/ogle|' ogle/libdvdcontrol.la.old > ogle/libdvdcontrol.la
  doins ogle/libdvdcontrol.la
  mv ogle/.libs/libdvdcontrol.so.3.2.0U ogle/.libs/libdvdcontrol.so.3.2.0
  doins ogle/.libs/libdvdcontrol.so.3.2.0
  dosym /usr/lib/ogle/libdvdcontrol.so.3.2.0 /usr/lib/ogle/libdvdcontrol.so
  dosym /usr/lib/ogle/libdvdcontrol.so.3.2.0 /usr/lib/ogle/libdvdcontrol.so.3
  dosym /usr/lib/ogle /usr/lib/ogle/.libs

}

