# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-pilot/gnome-pilot-0.1.62.ebuild,v 1.2 2001/10/08 08:19:09 hallski Exp $


S=${WORKDIR}/${P}
DESCRIPTION="Gnome Pilot apps"
SRC_URI="http://www.eskil.org/gnome-pilot/download/tarballs/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/gnome-pilot/"

DEPEND=">=gnome-base/gnome-core-1.4.0.4-r1
	>=gnome-base/control-center-1.4.0.1-r1
	>=dev-libs/pilot-link-0.9.5"

src_compile() {
	CFLAGS="${CFLAGS} `gnome-config --cflags libglade vfs`"
	
	./configure --prefix=/usr	 				\
		    --with-gnome-libs=/usr/lib				\
		    --sysconfdir=/etc		 			\
		    --enable-usb-visor=yes 				\
		    --host=${CHOST} || die

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING* ChangeLog README NEWS
}
