# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/librsvg/librsvg-1.0.2.ebuild,v 1.2 2001/10/07 22:15:58 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="librsvg"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

RDEPEND="virtual/glibc
	 >=gnome-base/gnome-libs-1.4.1.2-r1
	 >=media-libs/freetype-2.0.1
	 >=dev-libs/libxml-1.8
	 >=media-libs/gdk-pixbuf-0.11.0-r1
         >=dev-libs/popt-1.5"

RDEPEND="${RDEPEND}"

src_compile() {                           
	./configure --host=${CHOST} 					\
		    --prefix=/usr	 				\
		    --sysconfdir=/etc					\
		    --localstatedir=/var/lib
	assert

	emake || die
}

src_install() {
	make prefix=${D}/usr						\
	     sysconfdir=${D}/etc					\
	     localstatedir=${D}/var/lib					\
	     install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README*
}

