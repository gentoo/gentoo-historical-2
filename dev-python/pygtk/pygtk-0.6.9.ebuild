# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtk/pygtk-0.6.9.ebuild,v 1.3 2002/08/16 02:49:58 murphy Exp $

S=${WORKDIR}/${P}

DESCRIPTION="GTK+ bindings for Python"

SRC_URI="ftp://ftp.gtk.org/pub/gtk/python/${P}.tar.gz"

HOMEPAGE="http://www.daa.com.au/~james/pygtk/"

DEPEND="virtual/python
        >=gnome-base/libglade-0.17-r6
	>=media-libs/imlib-1.8
	>=media-libs/gdk-pixbuf-0.9.0
        ( >=x11-libs/gtk+-1.2.10
	<x11-libs/gtk+-2.0.0 )"
RDEPEND="${DEPEND}"

KEYWORDS="x86 sparc sparc64"
LICENSE="LGPL-2.1"
SLOT="1.2"

src_compile() {

	./configure --infodir=/usr/share/info \
	            --mandir=/usr/share/man \
	            --prefix=/usr \
	            --with-libglade-config=/usr/bin/libglade-config \
	            --host=${CHOST} || die
	emake || die
}

src_install () {
	
	make prefix=${D}/usr install || die

#    make DESTDIR=${D} install || die
}

