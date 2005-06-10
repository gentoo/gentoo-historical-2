# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.8.2_beta2.ebuild,v 1.3 2005/06/10 17:29:24 flameeyes Exp $

# Missing USE-flags due to missing deps:
# media-vidoe/vlc:tremor - Enables Tremor decoder support
# media-video/vlc:tarkin - Enables experimental tarkin codec
# media-video/vlc:h264 - Enables H264 encoding support with libx264

# Missing USE-flags due to needed testing
# media-video/vlc:dirac - Enables experimental dirac codec

inherit libtool toolchain-funcs eutils wxwidgets

# Test date for current snapshot
TESTSNAPSHOT="20050607"
TEST_PV="${PN}-snapshot-${TESTSNAPSHOT}"

PATCHLEVEL="4"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"
# This is a test version, so a snapshot, use the alternative SRC_URI
#SRC_URI="http://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2
#	http://digilander.libero.it/dgp85/gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"
SRC_URI="http://download.videolan.org/pub/vlc/snapshots/${TEST_PV}.tar.gz
	http://digilander.libero.it/dgp85/gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"
S="${WORKDIR}/${TEST_PV}"

LICENSE="GPL-2"
SLOT="0"
# ~sparc keyword dropped due to missing daap dependency.. mark or use.mask it
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="a52 3dfx nls unicode debug altivec httpd vlm gnutls live v4l cdda ogg matroska dvb dvd vcd ffmpeg aac dts flac mpeg vorbis theora X opengl freetype svg fbcon svga oss aalib ggi libcaca esd arts alsa wxwindows ncurses xosd lirc joystick mozilla hal stream mp3 xv bidi gtk2 sdl png xml2 samba daap slp corba screen mod speex"

RDEPEND="hal? ( =sys-apps/hal-0.4* )
		cdda? ( >=dev-libs/libcdio-0.71
			>=media-libs/libcddb-0.9.5 )
		live? ( >=media-plugins/live-2005.01.29 )
		dvd? (  media-libs/libdvdread
				media-libs/libdvdcss
				>=media-libs/libdvdnav-0.1.9
				media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ogg? ( media-libs/libogg )
		matroska? ( >=media-libs/libmatroska-0.7.5 )
		mp3? ( media-libs/libmad )
		ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20050226-r1 )
		a52? ( media-libs/a52dec )
		dts? ( media-libs/libdts )
		flac? ( media-libs/flac )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		vorbis? ( media-libs/libvorbis )
		theora? ( media-libs/libtheora )
		X? ( virtual/x11 )
		xv? ( virtual/x11 )
		freetype? ( media-libs/freetype
			media-fonts/ttf-bitstream-vera )
		svga? ( media-libs/svgalib )
		ggi? ( media-libs/libggi )
		aalib? ( media-libs/aalib )
		libcaca? ( media-libs/libcaca )
		arts? ( kde-base/arts )
		alsa? ( virtual/alsa )
		wxwindows? ( =x11-libs/wxGTK-2.6* )
		ncurses? ( sys-libs/ncurses )
		xosd? ( x11-libs/xosd )
		lirc? ( app-misc/lirc )
		mozilla? ( www-client/mozilla )
		3dfx? ( media-libs/glide-v3 )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		gnutls? ( >=net-libs/gnutls-1.0.17 )
		opengl? ( virtual/opengl )
		sys-libs/zlib
		png? ( media-libs/libpng )
		media-libs/libdvbpsi
		aac? ( >=media-libs/faad2-2.0-r2 )
		sdl? ( >=media-libs/libsdl-1.2.8 )
		xml2? ( dev-libs/libxml2 )
		samba? ( net-fs/samba )
		vcd? ( >=dev-libs/libcdio-0.72
			>=media-video/vcdimager-0.7.21 )
		daap? ( >=media-libs/libopendaap-0.3.0 )
		slp? ( net-libs/openslp )
		corba? ( >=gnome-base/orbit-2.8.0
			>=dev-libs/glib-2.3.2 )
		v4l? ( sys-kernel/linux-headers )
		dvb? ( sys-kernel/linux-headers )
		joystick? ( sys-kernel/linux-headers )
		mod? ( media-libs/libmodplug )
		speex? ( media-libs/speex )
		svg? ( >=gnome-base/librsvg-2.5.0 )"
#		threads? ( dev-libs/pth )
#		portaudio? ( >=media-libs/portaudio-0.19 )

DEPEND="${RDEPEND}
	dev-util/cvs
	>=sys-devel/gettext-0.11.5
	=sys-devel/automake-1.6*
	sys-devel/autoconf
	dev-util/pkgconfig"


pkg_setup() {
	if use wxwindows; then
		WX_GTK_VER="2.6"
		if use gtk2; then
			if use unicode; then
				need-wxwidgets unicode || die "You need to install wxGTK with unicode support."
			else
				need-wxwidgets gtk2 || die "You need to install wxGTK with gtk2 support."
			fi
		else
			need-wxwidgets gtk || die "You need to install wxGTK with gtk support."
		fi
	fi
}

src_unpack() {
	unpack ${A}

	# We only have glide v3 in portage
	cd ${S}

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/${PV}"

	./bootstrap

	sed -i -e \
		"s:/usr/include/glide:/usr/include/glide3:;s:glide2x:glide3:" \
		configure || die "sed glide failed."

	# Fix the default font
	sed -i -e "s:/usr/share/fonts/truetype/freefont/FreeSerifBold.ttf:/usr/share/fonts/ttf-bitstream-vera/VeraBd.ttf:" modules/misc/freetype.c
}

src_compile () {
	# Avoid timestamp skews with autotools
	touch configure.ac
	touch aclocal.m4
	touch configure
	touch config.h.in
	find . -name Makefile.in | xargs touch

	# reason why:
	# skins2 interface is horribly broken for some reason.
	# Therefore it's being disabled for the standard wxwindows
	# interface which isn't
	myconf="${myconf} --disable-skins2"

	# reason why:
	# mozilla-config is not in ${PATH}
	# so the configure script won't find it
	# unless we setup the proper variable
	if use mozilla ; then
		myconf="${myconf} --enable-mozilla MOZILLA_CONFIG=/usr/lib/mozilla/mozilla-config"
	else
		myconf="${myconf} --disable-mozilla"
	fi

	if use wxwindows; then
		myconf="${myconf} --with-wx-config=$(basename ${WX_CONFIG}) --with-wx-config-path=$(dirname ${WX_CONFIG})"
	fi

	if use ffmpeg; then
		myconf="${myconf} --enable-ffmpeg"

		built_with_use media-video/ffmpeg aac \
			&& myconf="${myconf} --with-ffmpeg-aac"

		built_with_use media-video/ffmpeg dts \
			&& myconf="${myconf} --with-ffmpeg-dts"

		built_with_use media-video/ffmpeg zlib \
			&& myconf="${myconf} --with-ffmpeg-zlib"

		built_with_use media-video/ffmpeg encode \
			&& myconf="${myconf} --with-ffmpeg-mp3lame"

	else
		myconf="${myconf} --disable-ffmpeg"
	fi

	# Portaudio support needs at least v19
	# pth (threads) support is quite unstable with latest ffmpeg/libmatroska.
	econf \
		$(use_enable altivec) \
		$(use_enable unicode utf8) \
		$(use_enable stream sout) \
		$(use_enable httpd) \
		$(use_enable vlm) \
		$(use_enable gnutls) \
		$(use_enable v4l) \
		$(use_enable cdda) $(use_enable cdda cddax)\
		$(use_enable vcd) $(use_enable vcd vcdx) \
		$(use_enable dvb) $(use_enable dvb pvr) \
		$(use_enable ogg) \
		$(use_enable matroska mkv) \
		$(use_enable flac) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable X x11) \
		$(use_enable xv xvideo) \
		$(use_enable opengl glx) $(use_enable opengl) \
		$(use_enable freetype) \
		$(use_enable bidi fribidi) \
		$(use_enable dvd dvdread) $(use_enable dvd dvdplay) $(use_enable dvd dvdnav) \
		$(use_enable fbcon fb) \
		$(use_enable svga svgalib) \
		$(use_enable 3dfx glide) \
		$(use_enable aalib aa) \
		$(use_enable libcaca caca) \
		$(use_enable oss) \
		$(use_enable esd) \
		$(use_enable arts) \
		$(use_enable alsa) \
		$(use_enable wxwindows) \
		$(use_enable ncurses) \
		$(use_enable xosd) \
		$(use_enable lirc) \
		$(use_enable joystick) \
		$(use_enable live livedotcom) $(use_with live livedotcom-tree /usr/lib/live) \
		$(use_enable mp3 mad) \
		$(use_enable aac faad) \
		$(use_enable a52) \
		$(use_enable dts) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable ggi) \
		$(use_enable 3dfx glide) \
		$(use_enable sdl) \
		$(use_enable hal) \
		$(use_enable png) \
		$(use_enable xml2 libxml2) \
		$(use_enable samba smb) \
		$(use_enable daap) \
		$(use_enable slp) \
		$(use_enable corba) \
		$(use_enable mod) \
		$(use_enable speex) \
		--disable-pth \
		--disable-portaudio \
		${myconf} || die "configuration failed"

	if [[ $(gcc-major-version) == 2 ]]; then
		sed -i -e s:"-fomit-frame-pointer":: vlc-config || die "-fomit-frame-pointer patching failed"
	fi

	# reason why:
	# looks for xpidl in /usr/lib/mozilla/xpidl
	# and doesn't find it there because it's
	# in /usr/bin! - ChrisWhite
	if use mozilla; then
		sed -e "s:^XPIDL = .*:XPIDL = /usr/bin/xpidl:" -i mozilla/Makefile \
		|| die "could not fix XPIDL path"
	fi

	emake -j1 || die "make of VLC failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed!"

	dodoc ABOUT-NLS AUTHORS MAINTAINERS HACKING THANKS TODO NEWS README \
		doc/fortunes.txt doc/intf-cdda.txt doc/intf-vcd.txt

	rm -r ${D}/usr/share/vlc/vlc*.png ${D}/usr/share/vlc/vlc*.xpm ${D}/usr/share/vlc/vlc*.ico \
		${D}/usr/share/vlc/kvlc*.png ${D}/usr/share/vlc/kvlc*.xpm ${D}/usr/share/vlc/qvlc*.png \
		${D}/usr/share/vlc/qvlc*.xpm ${D}/usr/share/vlc/gvlc*.png ${D}/usr/share/vlc/gvlc*.xpm \
		${D}/usr/share/vlc/gvlc*.ico ${D}/usr/share/vlc/gnome-vlc*.png \
		${D}/usr/share/vlc/gnome-vlc*.xpm ${D}/usr/share/vlc/skins2 \
		${D}/usr/share/doc/vlc

	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${S}/share/vlc${res}x${res}.png vlc.png
	done

	make_desktop_entry vlc "VLC Media Player" vlc "AudioVideo;Player"
}
