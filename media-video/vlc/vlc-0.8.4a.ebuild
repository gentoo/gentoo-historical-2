# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.8.4a.ebuild,v 1.1 2005/12/13 12:19:57 flameeyes Exp $

inherit eutils wxwidgets flag-o-matic nsplugins multilib autotools toolchain-funcs

MY_P="${P/_beta/-test}"

PATCHLEVEL="11"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"

[[ ${MY_P} != "${P}" ]] && \
	SRC_URI="http://download.videolan.org/pub/videolan/testing/${MY_P}/${MY_P}.tar.bz2" \
	|| SRC_URI="http://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"

SRC_URI="${SRC_URI}
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="a52 3dfx nls debug altivec httpd vlm gnutls live v4l cdda ogg matroska
dvb dvd vcd ffmpeg aac dts flac mpeg vorbis theora X opengl freetype svg fbcon svga
oss aalib ggi libcaca esd arts alsa wxwindows ncurses xosd lirc joystick stream
mp3 xv bidi sdl png xml2 samba daap corba screen mod speex nsplugin shout real
win32codecs skins hal avahi"

RDEPEND="cdda? ( >=dev-libs/libcdio-0.71
			>=media-libs/libcddb-0.9.5 )
		live? ( >=media-plugins/live-2005.01.29 )
		dvd? (  media-libs/libdvdread
				media-libs/libdvdcss
				>=media-libs/libdvdnav-0.1.9
				media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ogg? ( media-libs/libogg )
		matroska? (
			>=dev-libs/libebml-0.7.6
			>=media-libs/libmatroska-0.7.5 )
		mp3? ( media-libs/libmad )
		ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20050226-r1 )
		a52? ( >=media-libs/a52dec-0.7.4-r3 )
		dts? ( >=media-libs/libdts-0.0.2-r3 )
		flac? ( media-libs/flac )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		vorbis? ( media-libs/libvorbis )
		theora? ( media-libs/libtheora )
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
		3dfx? ( media-libs/glide-v3 )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		gnutls? ( >=net-libs/gnutls-1.0.17 )
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
		corba? ( >=gnome-base/orbit-2.8.0
			>=dev-libs/glib-2.3.2 )
		v4l? ( sys-kernel/linux-headers )
		dvb? ( sys-kernel/linux-headers )
		joystick? ( sys-kernel/linux-headers )
		mod? ( media-libs/libmodplug )
		speex? ( media-libs/speex )
		svg? ( >=gnome-base/librsvg-2.5.0 )
		nsplugin? ( >=net-libs/gecko-sdk-1.7.8 )
		shout? ( media-libs/libshout )
		win32codecs? ( media-libs/win32codecs )
		hal? ( sys-apps/hal )
		avahi? ( >=net-dns/avahi-0.6 )
		X? ( || ( (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXinerama
			xv? ( x11-libs/libXv )
			) virtual/x11 )
			opengl? ( || ( media-libs/mesa virtual/opengl ) )
			)"

DEPEND="${RDEPEND}
	X? ( || ( ( x11-proto/xproto
		x11-proto/xextproto
		x11-base/xorg-server
		) virtual/x11 ) )
	=sys-devel/automake-1.6*
	sys-devel/autoconf
	sys-devel/libtool
	sys-devel/autoconf
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use wxwindows; then
		WX_GTK_VER="2.6"
		need-wxwidgets unicode || die "You need to install wxGTK with unicode support."
	fi

	if use skins && ! use freetype; then
		eerror "Trying to build with skins support but without freetype."
		die "You have to use 'freetype' to use 'skins'"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	AT_M4DIR="m4" eautoreconf
}

src_compile () {
	use nsplugin && myconf="${myconf} --with-mozilla-sdk-path=/usr/$(get_libdir)/gecko-sdk"

	use wxwindows && \
		myconf="${myconf} --with-wx-config=$(basename ${WX_CONFIG}) --with-wx-config-path=$(dirname ${WX_CONFIG})"

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

	econf \
		$(use_enable altivec) \
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
		$(use_enable wxwindows wxwidgets) \
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
		$(use_enable png) \
		$(use_enable xml2 libxml2) \
		$(use_enable samba smb) \
		$(use_enable daap) \
		$(use_enable corba) \
		$(use_enable mod) \
		$(use_enable speex) \
		$(use_enable nsplugin mozilla) \
		$(use_enable shout) \
		$(use_enable real) $(use_enable real realrtsp) \
		$(use_enable win32codecs loader) \
		$(use_enable skins skins2) \
		$(use_enable hal) \
		$(use_enable avahi bonjour) \
		--disable-pth \
		--disable-portaudio \
		--disable-slp \
		--disable-x264 \
		--enable-utf8 \
		${myconf} || die "configuration failed"

	if [[ $(gcc-major-version) == 2 ]]; then
		sed -i -e s:"-fomit-frame-pointer":: vlc-config || die "-fomit-frame-pointer patching failed"
	fi

	emake || die "make of VLC failed"
}

src_install() {
	make DESTDIR="${D}" plugindir="/usr/$(get_libdir)/${PLUGINS_DIR}" install || die "Installation failed!"

	dodoc AUTHORS MAINTAINERS HACKING THANKS TODO NEWS README \
		doc/fortunes.txt doc/intf-cdda.txt doc/intf-vcd.txt

	rm -rf ${D}/usr/share/doc/vlc \
		${D}/usr/share/vlc/vlc{16x16,32x32,48x48,128x128}.{png,xpm,ico}

	use skins || rm -rf ${D}/usr/share/vlc/skins2

	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${S}/share/vlc${res}x${res}.png vlc.png
	done

	domenu "${S}/debian/vlc.desktop"
}
