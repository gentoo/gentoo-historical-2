# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/media-libs/xine-lib/xine-lib-1_beta4.ebuild,v 1.1 2003/01/29 23:06:22 agenkin Exp $ 

DESCRIPTION="Core libraries for Xine movie player."
HOMEPAGE="http://xine.sourceforge.net/"
LICENSE="GPL-2"

DEPEND="oggvorbis? ( media-libs/libvorbis )
	X? ( virtual/x11 )
	avi? ( >=media-libs/win32codecs-0.50 
	       media-libs/divx4linux )
	esd? ( media-sound/esound )
	dvd? ( >=media-libs/libdvdcss-0.0.3.3
	       >=media-libs/libdvdread-0.9.2 )
	arts? ( kde-base/kdelibs )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	directfb? ( >=dev-libs/DirectFB-0.9.9
		    dev-util/pkgconfig )
	media-libs/flac
	>=media-libs/libsdl-1.1.5"

RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

IUSE="arts esd avi nls dvd aalib X directfb oggvorbis alsa"

SLOT="0"
KEYWORDS="~x86"

S=${WORKDIR}/${PN}-${PV/_/-}
SRC_URI="mirror://sourceforge/xine/${PN}-${PV/_/-}.tar.gz"

# this build doesn't play nice with -maltivec (gcc 3.2 only option) on ppc
inherit flag-o-matic  || die "I lost my inheritance"											   
filter-flags "-maltivec -mabi=altivec" 

src_compile() {

	# Use the built-in dvdnav plugin.
	local myconf="--with-included-dvdnav"
	
	# Most of these are not working currently, but are here for completeness
	# don't use the --disable-XXXtest because that defaults to ON not OFF
	use X \
		|| myconf="${myconf} --disable-x11" # --disable-xv"
	use esd	\
		|| myconf="${myconf} --disable-esd" # --disable-esdtest"
	use nls	\
		|| myconf="${myconf} --disable-nls"
	use alsa \
		|| myconf="${myconf} --disable-alsa" # --disable-alsatest"
	use arts \
		|| myconf="${myconf} --disable-arts" # --disable-artstest"
	use aalib \
		|| myconf="${myconf} --disable-aalib" # --disable-aalibtest"
	use oggvorbis \
		|| myconf="${myconf} --disable-ogg --disable-vorbis"
			   #--disable-oggtest --disable-vorbistest"
	use avi	\
		&& myconf="${myconf} --with-w32-path=/usr/lib/win32" \
		|| myconf="${myconf} --disable-asf"

	einfo "myconf: ${myconf}"

	# Very specific optimization is set by configure
	# Should fix problems like the one found on bug #11779
	# raker@gentoo.org (25 Dec 2002)
	unset CFLAGS
	unset CXXFLAGS

	econf ${myconf} || die
	make || die
}

src_install() {
	
	einstall || die

	# Xine's makefiles install some file incorrectly. (Gentoo bug #8583).
	dodir /usr/share/xine/fonts
	mv ${D}/usr/share/*.xinefont.gz ${D}/usr/share/xine/fonts/
	dodir /usr/share/xine/skins
	mv ${D}/usr/share/xine_logo.mpv ${D}/usr/share/xine/skins/

	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
	cd ${S}/doc
	dodoc dataflow.dia README*

}

pkg_postinst() {

	einfo
	einfo "Please note, a new version of xine-lib has been installed,"
	einfo "for library consistency you need to unmerge old versions"
	einfo "of xine-lib before merging xine-ui."
	einfo
	einfo "This library version 1 is incompatible with the plugins,"
	einfo "designed for the prior library versions (such as xine-d4d,"
	einfo "xine-d5d, xine-dmd, and xind-dvdnav."
	einfo 
	einfo "Also make sure to remove your ~/.xine if upgrading from"
	einfo "a previous version."
	einfo

}
