# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/xine-lib/xine-lib-0.9.7.ebuild,v 1.2 2002/01/25 09:29:30 gbevin Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Xine is a free gpl-licensed video player for unix-like systems"
SRC_URI="http://skyblade.homeip.net/xine/XINE-${PV}/source.TAR.BZ2s/xine-lib-${PV}.tar.bz2"
HOMEPAGE="http://xine.sourceforge.net/"

DEPEND="virtual/glibc
	>=media-libs/libdvdcss-0.0.3.3
	>=media-libs/libdvdread-0.9.2
	>=media-libs/win32codecs-0.50
	>=media-libs/aalib-1.4_rc3
	X? ( virtual/x11 )
	esd? ( media-sound/esound )
	arts? ( kde-base/kdelibs )
	alsa? ( media-libs/alsa-lib )
	ogg? ( media-libs/libogg )
	vorbis? ( media-libs/libvorbis )"


src_compile() {

	# Most of these are not working currently, but are here for completeness
	local myconf
	use X      || myconf="${myconf} --disable-x11 --disable-xv"
	use alsa   || myconf="${myconf} --disable-alsa --disable-alsatest"
	use esd    || myconf="${myconf} --disable-esd --disable-esdtest"
#	use aalib  || myconf="${myconf} --disable-aalib --disable-aalibtest"
	use arts   || myconf="${myconf} --disable-arts --disable-artstest"
	use ogg    || myconf="${myconf} --disable-ogg --disable-oggtest"
	use vorbis || myconf="${myconf} --disable-vorbis --disable-vorbistest"
	 
	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
		    --mandir=/usr/share/man				\
		    --infodir=/usr/share/info				\
		    --sysconfdir=/etc					\
		    --with-w32-path=/usr/lib/win32			\
		    ${myconf} || die
		    
	make || die
}

src_install() {
	
	make prefix=${D}/usr						\
	     mandir=${D}/usr/share/man					\
	     infodir=${D}/usr/share/info				\
	     docdir=${D}/usr/share/doc/${PF}/html			\
	     sysconfdir=${D}/etc					\
	     install || die

	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
	cd ${S}/doc
	dodoc dataflow.dia README*
}

