# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/gdk-pixbuf/gdk-pixbuf-0.16.0-r7.ebuild,v 1.4 2002/04/04 02:01:46 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNOME Image Library"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/${PN}/${P}.tar.gz"

DEPEND=">=x11-libs/gtk+-1.2.10-r4
	media-libs/libpng
	media-libs/tiff
	media-libs/jpeg
	dev-libs/glib
	sys-libs/zlib
	>=gnome-base/gnome-libs-1.4.1.2-r1"
# We need gnome-libs here, else gnome support do not get compiled into
# gdk-pixbuf (the GnomeCanvasPixbuf library )

src_unpack() {

	unpack ${A}

	cp ${S}/demo/Makefile.in ${S}/demo/Makefile.in.orig
	sed -e 's:LDADD = :LDADD = $(LIBJPEG) $(LIBTIFF) $(LIBPNG) :' \
		${S}/demo/Makefile.in.orig > ${S}/demo/Makefile.in
}

src_compile() {

	#update libtool, else we get the "relink bug"
	libtoolize --copy --force
	aclocal
	autoconf
	automake --add-missing

	./configure 	\
		--host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc/X11/gdk-pixbuf || die

	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --sysconfdir=/etc/X11/gdk-pixbuf || die
	
	# Mandrake's hack to allow compiling without the X display
	XDISPLAY=$(i=0; while [ -f /tmp/.X${i}-lock ] ; do i=$((${i}+1));done; echo ${i})
	/usr/X11R6/bin/Xvfb :${XDISPLAY} >& /dev/null &
	DISPLAY=:${XDISPLAY} emake || die

	kill $(cat /tmp/.X${XDISPLAY}-lock)
	
}

src_install() {

	make 	\
		prefix=${D}/usr \
		sysconfdir=${D}/etc/X11/gdk-pixbuf \
		install || die

	#fix permissions on the loaders
	chmod a+rx ${D}/usr/lib/gdk-pixbuf/loaders
	chmod a+r ${D}/usr/lib/gdk-pixbuf/loaders/*

	dodoc AUTHORS COPYING* ChangeLog INSTALL README NEWS TODO
}

