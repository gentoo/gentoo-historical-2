# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins/gst-plugins-0.4.1-r1.ebuild,v 1.5 2002/12/18 13:12:53 foser Exp $

inherit libtool gnome2 flag-o-matic

IUSE="encode quicktime mpeg oggvorbis jpeg esd gnome mikmod avi sdl png alsa arts dvd aalib"
S=${WORKDIR}/${P}
DESCRIPTION="Additional plugins for gstreamer - streaming media framework"
SRC_URI="mirror://sourceforge/gstreamer/${P}.tar.gz"
HOMEPAGE="http://gstreamer.sourceforge.net"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~sparc"

# required packages
# there are many many optional libraries. features are compiled if the libraries
# are present. most optional libraries are from gnome.
DEPEND=">=media-libs/gstreamer-0.4.1
	>=gnome-base/gconf-1.2.0
	media-sound/mad
	media-libs/flac
	media-sound/cdparanoia
	media-libs/hermes
	>=media-libs/libdv-0.9.5
	encode? ( media-sound/lame )
	quicktime? ( media-libs/openquicktime )
	mpeg? (	=media-libs/libmpeg2-0.2* )
	oggvorbis? ( 	media-libs/libvorbis 
			media-libs/libogg )
	jpeg? (	media-video/mjpegtools 
		>=media-libs/jpeg-mmx-1.1.2-r1 )
	esd? ( media-sound/esound )
	gnome? ( >=gnome-base/gnome-vfs-2.0.1 )
	mikmod? ( media-libs/libmikmod )
	sdl? ( media-libs/libsdl )
	png? ( >=media-libs/libpng-1.2.3 )
	alsa? ( >=media-libs/alsa-lib-0.9.0_rc2 
		media-sound/jack-audio-connection-kit )
	arts? ( >=kde-base/arts-1.0.2 )
	dvd? ( 	media-libs/libdvdnav )
	aalib? ( media-libs/aalib )
	media-libs/ladspa-sdk" 

# disable avi for now, it doesnt work
#	avi? ( media-video/avifile )


src_compile() {
	elibtoolize
	replace-flags "-O3" "-O2"

	# this is an ugly patch to remove -I/usr/include from some CFLAGS
	patch -p0 <${FILESDIR}/${P}-configure.patch

	local myconf
	myconf=""
	use avi \
		&& myconf="${myconf} --enable-avifile" \
		|| myconf="${myconf} --disable-avifile"
	use aalib \
		&& myconf="${myconf} --enable-aalib" \
		|| myconf="${myconf} --disable-aalib"
	use dvd \
		&& myconf="${myconf} --enable-dvdread --enable-dvdnav
				 --enable-libdv" \
		|| myconf="${myconf} --disable-dvdread --disable-dvdnav
				 --disable-libdv"

	# not testing for much here, since if its in USE we want it, but its autodetected by configure
	
	./configure \
		${myconf} \
		--without-vorbis-includes \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--oldincludedir=/usr/include \
		--sysconfdir=/etc \
		--mandir=/usr/share/man || die "./configure failed"
		
	emake || die
}

src_install () {
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"		
	make DESTDIR=${D} install || die
	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	
	dodoc AUTHORS COPYING INSTALL README RELEASE TODO 
}

pkg_postinst () {
	gnome2_gconf_install
	gst-register
}
