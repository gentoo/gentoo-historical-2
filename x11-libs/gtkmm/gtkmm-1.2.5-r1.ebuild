# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkmm/gtkmm-1.2.5-r1.ebuild,v 1.1 2001/10/06 10:08:20 azarah Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="gtk"
SRC_URI="http://download.sourceforge.net/gtkmm/${A}"
#	 ftp://ftp.gnome.org/pub/GNOME/stable/sources/gtk+/${A}
#	 http://ftp.gnome.org/pub/GNOME/stable/sources/gtk+/${A}"
HOMEPAGE="http://gtkmm.sourceforge.net/"

DEPEND="virtual/glibc
	>=x11-libs/gtk+-1.2.10-r4
	>=dev-libs/libsigc++-1.0.0"

src_compile() {
	local myconf
	
	if [ "${DEBUG}" ]
	then
		myconf="--enable-debug=yes"
	else
		myconf="--enable-debug=no"
	fi
	
  	try ./configure --host=${CHOST} --prefix=/usr ${myconf} \
	--infodir=/usr/share/info --mandir=/usr/share/man --sysconfdir=/etc/X11 \
	--with-xinput=xfree --with-x
	try make
}

src_install() {
	try make install DESTDIR=${D}


	dodoc AUTHORS COPYING ChangeLog* HACKING
	dodoc NEWS* README* TODO
  	#install nice, clean-looking default gtk+ style
}




