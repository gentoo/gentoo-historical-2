# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Geert Bevin <gbevin@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/glib/glib-2.0.1-r2.ebuild,v 1.2 2002/04/27 23:08:36 bangert Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The GLib library of C routines"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v2.0/${P}.tar.bz2"
HOMEPAGE="http://www.gtk.org/"

SLOT="2"

DEPEND="virtual/glibc
		>=dev-util/pkgconfig-0.12.0
		doc? ( >=dev-util/gtk-doc-0.9-r2 )"

src_compile() {
	libtoolize --copy --force
	local myconf
	use doc && myconf="${myconf} --enable-gtk-doc" || myconf="${myconf} --disable-gtk-doc"
	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --infodir=/usr/share/info \
		    --mandir=/usr/share/man \
		    --with-threads=posix \
			${myconf} \
		    --enable-debug=yes || die
# you cannot disable debug or this will fail building.
# odd but true :/

	emake || die
}

src_install() {
	make prefix=${D}/usr \
	     infodir=${D}/usr/share/info \
	     mandir=${D}/usr/share/man \
	     install || die
    
	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS NEWS.pre-1-3 TODO.xml
}





