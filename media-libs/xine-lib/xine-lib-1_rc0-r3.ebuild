# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xine-lib/xine-lib-1_rc0-r3.ebuild,v 1.1 2003/08/18 18:02:01 agenkin Exp $ 

# this build doesn't play nice with -maltivec (gcc 3.2 only option) on ppc
# Commenting this out in this ebuild, because CFLAGS and CXXFLAGS are unset
# at make time any way.
# Brandon Low (29 Apr 2003)
# inherit flag-o-matic
# filter-flags "-maltivec -mabi=altivec"
# replace-flags k6-3 i686
# replace-flags k6-2 i686
# replace-flags k6   i686

#13 Jul 2003: drobbins: build failure using -j5 on a dual Xeon in 1_beta12
MAKEOPTS="$MAKEOPTS -j1"

# This should normally be empty string, unless a release has a suffix.
MY_PKG_SUFFIX="a"

DESCRIPTION="Core libraries for Xine movie player"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${PN}-${PV/_/-}${MY_PKG_SUFFIX}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~hppa ~sparc"
IUSE="arts esd avi nls dvd aalib X directfb oggvorbis alsa gnome sdl"

DEPEND="oggvorbis? ( media-libs/libvorbis )
	X? ( virtual/x11 )
	avi? ( x86? ( >=media-libs/win32codecs-0.50 
	       media-libs/divx4linux ) )
	esd? ( media-sound/esound )
	dvd? ( >=media-libs/libdvdcss-1.2.7 )
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	directfb? ( >=dev-libs/DirectFB-0.9.9
		    dev-util/pkgconfig )
	gnome? ( >=gnome-base/gnome-vfs-2.0 
			dev-util/pkgconfig )
	>=media-libs/flac-1.0.4
	sdl? ( >=media-libs/libsdl-1.1.5 )
	>=media-libs/libfame-0.9.0
	>=media-libs/xvid-0.9.0
	media-libs/speex"
RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${PV/_/-}${MY_PKG_SUFFIX}

src_compile() {
	# Make sure that the older libraries are not installed (bug #15081).
	if [ -f /usr/lib/libxine.so.0 ]
	then
		einfo "Please uninstall older xine libraries.";
		einfo "The compilation cannot proceed.";
		die
	fi

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
	use sdl \
		|| myconf="${myconf} --with-sdl-prefix=/null" # disable sdl check

	einfo "myconf: ${myconf}"

	# Very specific optimization is set by configure
	# Should fix problems like the one found on bug #11779
	# raker@gentoo.org (25 Dec 2002)
	unset CFLAGS
	unset CXXFLAGS

	econf ${myconf} || die "Configure failed"

	emake || die "Parallel make failed"
}

src_install() {
	einstall || die "Install failed"

	# Xine's makefiles install some file incorrectly. (Gentoo bug #8583, #16112).
	dodir /usr/share/xine/libxine1/fonts
	mv ${D}/usr/share/*.xinefont.gz ${D}/usr/share/xine/libxine1/fonts/

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
	einfo "xine-d5d, xine-dmd, and xine-dvdnav."
	einfo 
	einfo "Also make sure to remove your ~/.xine if upgrading from"
	einfo "a previous version."
	einfo
}
