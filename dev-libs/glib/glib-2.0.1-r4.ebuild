# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Spider <spider@gentoo.org>
# Maintainer: Spider <spider@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/glib/glib-2.0.1-r4.ebuild,v 1.1 2002/05/03 16:44:24 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The GLib library of C routines"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v2.0/${P}.tar.bz2"
HOMEPAGE="http://www.gtk.org/"
LICENSE="LGPL-2.1"
SLOT="2"

DEPEND="virtual/glibc
		>=dev-util/pkgconfig-0.12.0
		doc? ( >=dev-util/gtk-doc-0.9-r2 )"
#		>=dev-libs/libiconv-1.7
# this breaks other stuff

RDEPEND="virtual/glibc"
#		>=dev-libs/libiconv-1.7"

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

# This had to be removed since it broke other stuff. darn. 2002-05-03
#	--with-libiconv=gnu \

 
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





