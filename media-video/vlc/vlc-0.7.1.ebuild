# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.7.1.ebuild,v 1.4 2004/06/09 17:44:12 agriffis Exp $

inherit libtool gcc eutils

# Missing support for...
#	tarkin - package not in portage yet - experimental
#	theora - package not in portage yet - experimental
#	tremor - package not in portage yet - experimental

# Change these to correspond with the
# unpacked dirnames of the CVS snapshots.
PLIVE=live

SLIVE=${WORKDIR}/${PLIVE}
S=${WORKDIR}/${P}

DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc"
SRC_URI="http://download.videolan.org/pub/${PN}/${PV}/${P}.tar.bz2
		 http://download.videolan.org/pub/${PN}/${PV}/contrib/live.2004.02.26.tar.gz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 -ppc"
IUSE="arts qt ncurses dvd gtk nls 3dfx svga fbcon esd kde X alsa ggi speex
	oggvorbis gnome xv oss sdl aalib slp truetype v4l xvid lirc bidi
	wxwindows imlib mozilla dvb debug faad xosd matroska altivec png"

RDEPEND="X? ( virtual/x11 )
	aalib? ( >=media-libs/aalib-1.4_rc4-r2
			>=media-libs/libcaca-0.9 )
	alsa? ( >=media-libs/alsa-lib-0.9_rc2 )
	arts? ( kde-base/kdelibs )
	dvb? ( media-libs/libdvb
		media-tv/linuxtv-dvb )
	dvd? ( >=media-libs/libdvdread-0.9.4
		>=media-libs/libdvdcss-1.2.8
		>=media-libs/libdvdplay-1.0.1 )
	esd? ( >=media-sound/esound-0.2.22 )
	faad? ( >=media-libs/faad2-2.0_rc3 )
	ggi? ( >=media-libs/libggi-2.0_beta3 )
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )
	gtk? ( =x11-libs/gtk+-1.2* )
	imlib? ( >=media-libs/imlib2-1.0.6 )
	kde? ( kde-base/kdelibs )
	lirc? ( app-misc/lirc )
	mad? ( media-libs/libmad media-libs/libid3tag )
	matroska? ( >=media-libs/libmatroska-0.6.2 )
	mozilla? ( >=net-www/mozilla-1.4 )
	ncurses? ( sys-libs/ncurses )
	nls? ( >=sys-devel/gettext-0.12.1 )
	oggvorbis? ( >=media-libs/libvorbis-1.0 >=media-libs/libogg-1.0 )
	qt? ( x11-libs/qt )
	sdl? ( >=media-libs/libsdl-1.2.5 )
	slp? ( >=net-libs/openslp-1.0.10 )
	truetype? ( >=media-libs/freetype-2.1.4 )
	wxwindows? ( >=x11-libs/wxGTK-2.4.1 )
	xosd? ( >=x11-libs/xosd-2.0 )
	xvid? ( >=media-libs/xvid-0.9.1 )
	3dfx? ( media-libs/glide-v3 )
	bidi? ( >=dev-libs/fribidi-0.10.4 )
	png? ( >=media-libs/libpng-1.2.5 )
	speex? ( >=media-libs/speex-1.0.3 )
	svga? ( media-libs/svgalib )
	>=media-libs/a52dec-0.7.4
	>=media-sound/lame-3.93.1
	>=media-libs/flac-1.1.0
	>=media-libs/libmpeg2-0.4.0
	>=media-video/ffmpeg-0.4.8.20040222
	>=media-libs/libdvbpsi-0.1.3"

DEPEND="$RDEPEND >=sys-devel/autoconf-2.58"

# liveMedia (live.com) is not a true library but needs to be 'imported'
# into your own sourcetree. This is against VLC coding policy.

# get kde and arts paths
if use kde || use arts; then
	inherit kde-functions
	set-kdedir 3
	# $KDEDIR is now set to arts/kdelibs location
fi

src_unpack() {
	unpack ${A}

	cd ${SLIVE}
	epatch ${FILESDIR}/live-gcc3-3.patch

	# if qt3 is installed, patch vlc to work with it instead of qt2
	if use qt || use kde
	then
		if [ ${QTDIR} = "/usr/qt/3" ]
		then
			sed -i -e "s:-lkfile::" configure

			cd ${S}/modules/gui/kde
			sed -i \
				"s:\(#include <kmainwindow.h>\):\1\n#include <kstatusbar.h>:" \
				interface.h

			sed -i \
				's:\("vlc preferences", true, false, \)\("Save\):\1(KGuiItem)\2:' \
				preferences.cpp
		fi
	fi

	# We only have glide v3 in portage
	cd ${S}
	sed -i \
		-e "s:/usr/include/glide:/usr/include/glide3:" \
		-e "s:glide2x:glide3:" \
		configure

	cd ${S}/modules/video_output
	epatch ${FILESDIR}/glide.patch
	cd ${S}

	cd ${S}
	# Avoid timestamp skews with autotools
	touch configure.ac
	touch aclocal.m4
	touch configure
	touch config.h.in
	touch $(find . -name Makefile.in)
}

src_compile() {
	# configure and building of livedotcom
	cd ${SLIVE}
	./genMakefiles linux || die "Creating liveMedia Makefiles failed."
	make || die "liveMedia code failed to compile."

	# Configure and build VLC
	cd ${S}
	local myconf
	myconf="--disable-mga --enable-flac --with-gnu-ld \
			--enable-a52 --enable-dvbpsi --enable-libmpeg2
			--disable-kde"

	#--enable-pth            GNU Pth support (default disabled)
	#--enable-st             State Threads (default disabled)
	#--enable-gprof          gprof profiling (default disabled)
	#--enable-cprof          cprof profiling (default disabled)
	#--enable-mostly-builtin most modules will be built-in (default disabled)
	#--disable-optimizations disable compiler optimizations (default enabled)
	#--enable-testsuite      build test modules (default disabled)
	#--disable-plugins       make all plugins built-in (default plugins enabled)

	use debug && myconf="${myconf} --enable-debug" \
		|| myconf="${myconf} --enable-release"

	(use imlib && use wxwindows) && myconf="${myconf} --enable-skins"

	use mozilla \
		&& myconf="${myconf} --enable-mozilla \
		MOZILLA_CONFIG=/usr/lib/mozilla/mozilla-config \
		XPIDL=/usr/bin/xpidl"

	# vlc uses its own ultraoptimizaed CXXFLAGS
	# and forcing custom ones generally fails building
	export CXXFLAGS=""
	export CFLAGS=""
	export WANT_AUTOCONF_2_5=1
	export WANT_AUTOMAKE_1_6=1

	myconf="${myconf} --enable-ffmpeg \
		--with-ffmpeg-mp3lame \
		--enable-livedotcom \
		--with-livedotcom-tree=${SLIVE}"

	econf \
		$(use_enable nls) \
		$(use_enable slp) \
		$(use_enable xosd) \
		$(use_enable ncurses) \
		$(use_enable alsa) \
		$(use_enable esd) \
		$(use_enable oss) \
		$(use_enable ggi) \
		$(use_enable sdl) \
		$(use_enable mad) \
		$(use_enable faad) \
		$(use_enable xvid) \
		$(use_enable v4l) \
		$(use_enable dvd) \
		$(use_enable dvd vcd) $(use_enable dvdread) $(use_enable dvd dvdplay) \
		$(use_enable dvb satellite) $(use_enable dvb pvr) \
		$(use_enable joystick) $(use_enable lirc) \
		$(use_enable qt) $(use_enable arts) \
		$(use_enable gtk) $(use_enable gnome) \
		$(use_enable oggvorbis ogg) $(use_enable oggvorbis vorbis) \
		$(use_enable speex) \
		$(use_enable matroska mkv) \
		$(use_enable truetype freetype) \
		$(use_enable bidi fribidi) \
		$(use_enable svga svgalib) \
		$(use_enable fbcon fb) \
		$(use_enable aalib aa) $(use_enable aalib caca) \
		$(use_enable xv xvideo) \
		$(use_enable X x11) \
		$(use_enable 3dfx glide) \
		$(use_enable altivec) \
		${myconf} || die "configure of VLC failed"

	if [[ $(gcc-major-version) == 2 ]]; then
		sed -i -e s:"-fomit-frame-pointer":: vlc-config || die
	fi

	# parallel make doesn't work with our complicated makefile
	# this is also the reason as why you shouldn't run autoconf
	# or automake yourself. (or bootstrap for that matter)
	MAKEOPTS="${MAKEOPTS} -j1"
	emake || die "make of VLC failed"
}

src_install() {
	einstall || die "make install failed"

	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog HACKING INSTALL* \
	MAINTAINERS NEWS README* THANKS doc/ChangeLog-*
}
