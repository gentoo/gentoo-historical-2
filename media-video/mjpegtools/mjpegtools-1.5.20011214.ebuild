# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# Heavily modified by Ryan Tolboom <ryan@gentoo.org>
# /space/gentoo/cvsroot/gentoo-x86/media-video/mjpegtools/mjpegtools-1.5.20011611-r1.ebuild,v 1.1 2001/12/11 19:39:34 ryan Exp

A=${PN}-1.5-20011214.tar.gz
S=${WORKDIR}/${PN}-1.5-20011214
DESCRIPTION="Tools for MJPEG video"
SRC_URI="http://download.sourceforge.net/mjpeg/${A}
	 quicktime? ( http://download.sourceforge.net/mjpeg/quicktime4linux-1.4-patched.tar.gz )"
HOMEPAGE="http://mjpeg.sourceforge.net/"

RDEPEND=">=media-libs/jpeg-6b
	gtk? ( >=x11-libs/gtk+-1.2.10-r4 )
	sdl? ( >=media-libs/libsdl-1.2.2 )
	X? ( >=x11-base/xfree-4.1.0 )
	avi? ( >=media-video/avifile-0.6.0.20011130 )"

DEPEND="${RDEPEND}
	quicktime? ( >=media-libs/libpng-1.0.12 )
	libmovtar? ( >=media-libs/libmovtar-0.1.2 )
	mmx? ( >=media-libs/jpeg-mmx-1.1.2 )"

src_unpack() {

	unpack ${A}
	if [ "`use quicktime`" ] ; then
		cd quicktime4linux-1.4-patch
		cp libmjpeg.h libmjpeg.h.orig
		sed -e "s:\"jpeg/jpeglib.h\":<jpeglib.h>:" libmjpeg.h.orig > libmjpeg.h
		cp jpeg_old.h jpeg_old.h.orig
		sed -e "s:\"jpeg/jpeglib.h\":<jpeglib.h>:" jpeg_old.h.orig > jpeg_old.h
	fi
	
	# if we aren't using X we have to change lavplay so it doesn't have hardware accel
	if [ -z "`use X`" ] ; then
		cd ${S}/lavtools
		cp Makefile.in Makefile.in.orig
		sed -e 's:-lX11::' Makefile.in.orig > Makefile.in
		cp liblavplay.c liblavplay.c.orig
		sed -e 's:^#include <X11/.*::' liblavplay.c.orig | sed -e 's:HAVE_V4L:HAVE_V4L_DUMMY:' > liblavplay.c
	fi
}

src_compile() {

	local myconf

	use gtk	\
		&& myconf="${myconf} --with-gtk-prefix=/usr"
	
	use X	\
		&& myconf="${myconf} --with-x"	\
		|| myconf="${myconf} --without-x"
	
	use mmx	\
		&& myconf="${myconf} --with-jpeg-mmx=/usr/include/jpeg-mmx --enable-mmx-accel"
	
	use avi	\
		|| myconf="${myconf} --without-aviplay"
	
	if [ "`use quicktime`" ] ; then
		myconf="${myconf} --with-quicktime=${WORKDIR}/quicktime4linux-1.4-patch"
		cd ${WORKDIR}/quicktime4linux-1.4-patch
		./configure || die
		make || die
	fi

	cd ${S}
	./configure 	\
		${myconf} || die

	emake || die

}

src_install () {

	make 	\
		prefix=${D}/usr	\
		mandir=${D}/usr/share/man	\
		install || die

	dodoc mjpeg_howto.txt

}
