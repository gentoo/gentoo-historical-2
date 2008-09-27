# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.9.3.ebuild,v 1.1 2008/09/27 07:50:45 aballier Exp $

EAPI="1"

WANT_AUTOMAKE=latest
WANT_AUTOCONF=latest

inherit eutils multilib autotools toolchain-funcs gnome2 nsplugins qt4 flag-o-matic

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-beta/-test}"
MY_P="${PN}-${MY_PV}"
VLC_SNAPSHOT_TIME="0013"

PATCHLEVEL="59"
M4_TARBALL_VERSION="1"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"
if [[ "${P}" == *_alpha* ]]; then # Snapshots taken from nightlies.videolan.org
	SRC_URI="http://nightlies.videolan.org/build/source/trunk-${PV/*_alpha/}-${VLC_SNAPSHOT_TIME}/${PN}-snapshot-${PV/*_alpha/}.tar.bz2"
	MY_P="${P/_alpha*/}-git"
elif [[ "${P}" == *_p* ]]; then # Snapshots
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	MY_P="${P}"
elif [[ "${MY_P}" == "${P}" ]]; then
	SRC_URI="http://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"
else
	SRC_URI="http://download.videolan.org/pub/videolan/testing/${MY_P}/${MY_P}.tar.bz2"
fi

SRC_URI="${SRC_URI}
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2
	mirror://gentoo/${PN}-m4-${M4_TARBALL_VERSION}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="a52 aac aalib alsa altivec arts atmo avahi bidi cdda cddb cdio dbus dc1394
	debug dirac directfb dts dvb dvd esd fbcon fluidsynth +ffmpeg flac fontconfig ggi gnome gnutls hal httpd
	id3tag jack kate libass libcaca +libgcrypt libnotify lirc live lua matroska mmx modplug mp3 mpeg
	musepack ncurses nsplugin ogg opengl optimisememory oss png	pulseaudio pvr +qt4
	remoteosd rtsp samba schroedinger sdl sdl-image seamonkey shout skins speex sse stream svg svga taglib
	theora truetype twolame upnp v4l v4l2 vcd vcdx vlm vorbis win32codecs
	X x264 xinerama xml xosd xv zvbi"

RDEPEND="
		sys-libs/zlib
		media-libs/libdvbpsi
		a52? ( >=media-libs/a52dec-0.7.4-r3 )
		aalib? ( media-libs/aalib )
		aac? ( >=media-libs/faad2-2.6.1 )
		alsa? ( media-libs/alsa-lib )
		arts? ( kde-base/arts )
		avahi? ( >=net-dns/avahi-0.6 )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		cdda? ( >=dev-libs/libcdio-0.72
			cddb? ( >=media-libs/libcddb-1.2.0 ) )
		cdio? ( >=dev-libs/libcdio-0.78.2
			>=media-video/vcdimager-0.7.22 )
		dbus? ( >=sys-apps/dbus-1.0.2 )
		dc1394? ( sys-libs/libraw1394
			<media-libs/libdc1394-1.9.99 )
		dirac? ( >=media-video/dirac-0.10.0 )
		directfb? ( dev-libs/DirectFB )
		dts? ( media-libs/libdca )
		dvd? (	media-libs/libdvdread
				media-libs/libdvdcss
				>=media-libs/libdvdnav-0.1.9
				media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20070616 )
		flac? ( media-libs/libogg
			>=media-libs/flac-1.1.2 )
		fluidsynth? ( media-sound/fluidsynth )
		fontconfig? ( media-libs/fontconfig )
		ggi? ( media-libs/libggi )
		gnome? ( gnome-base/gnome-vfs )
		gnutls? ( >=net-libs/gnutls-1.3.3 )
		hal? ( sys-apps/hal )
		id3tag? ( media-libs/libid3tag
			sys-libs/zlib )
		jack? ( >=media-sound/jack-audio-connection-kit-0.99.0-r1 )
		kate? ( >=media-libs/libkate-0.1.1 )
		libass? ( >=media-libs/libass-0.9.5 media-libs/fontconfig )
		libcaca? ( media-libs/libcaca )
		libgcrypt? ( >=dev-libs/libgcrypt-1.2.0 )
		libnotify? ( x11-libs/libnotify )
		lirc? ( app-misc/lirc )
		live? ( >=media-plugins/live-2008.07.06 )
		lua? ( >=dev-lang/lua-5.1 )
		matroska? (
			>=dev-libs/libebml-0.7.6
			>=media-libs/libmatroska-0.8.0 )
		modplug? ( media-libs/libmodplug )
		mp3? ( media-libs/libmad )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		musepack? ( media-libs/libmpcdec )
		ncurses? ( sys-libs/ncurses )
		nsplugin? (
			seamonkey?  ( =www-client/seamonkey-1* )
			!seamonkey? ( >=net-libs/xulrunner-1.8 )
		)
		ogg? ( media-libs/libogg )
		png? ( media-libs/libpng )
		pulseaudio? ( >=media-sound/pulseaudio-0.9.8 )
		qt4? ( || ( ( x11-libs/qt-gui x11-libs/qt-core ) =x11-libs/qt-4.3*:4 ) )
		remoteosd? ( >=dev-libs/libgcrypt-1.2.0 )
		samba? ( net-fs/samba )
		schroedinger? ( >=media-libs/schroedinger-1.0 )
		sdl? ( >=media-libs/libsdl-1.2.8
			sdl-image? ( media-libs/sdl-image ) )
		shout? ( media-libs/libshout )
		skins? ( || ( ( x11-libs/qt-gui x11-libs/qt-core ) =x11-libs/qt-4.3*:4 ) )
		speex? ( media-libs/speex )
		svg? ( >=gnome-base/librsvg-2.9.0 )
		svga? ( media-libs/svgalib )
		taglib? ( media-libs/taglib )
		theora? ( media-libs/libtheora )
		truetype? ( media-libs/freetype
			media-fonts/ttf-bitstream-vera )
		twolame? ( media-sound/twolame )
		upnp? ( net-libs/libupnp )
		vorbis? ( media-libs/libvorbis )
		win32codecs? ( media-libs/win32codecs )
		X? (
			x11-libs/libX11
			x11-libs/libXext
			xv? ( x11-libs/libXv )
			xinerama? ( x11-libs/libXinerama )
			opengl? ( virtual/opengl )
		)
		x264? ( media-libs/x264 )
		xml? ( dev-libs/libxml2 )
		xosd? ( x11-libs/xosd )
		zvbi? ( >=media-libs/zvbi-0.2.25 )
		"

# Disabled features and reasons:
# xvmc? ( x11-libs/libXvMC )
#	Will probably compile only on x86

DEPEND="${RDEPEND}
	dvb? ( sys-kernel/linux-headers )
	v4l? ( sys-kernel/linux-headers )
	v4l2? ( sys-kernel/linux-headers )
	X? ( xinerama? ( x11-proto/xineramaproto ) )
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

# Dispalys a warning if the first use flag is set but not the second
vlc_use_needs() {
	use $1 && use !$2 && ewarn "USE=$1 requires $2, $1 will be disabled."
}

# Notify the user that some useflag have been forced on
vlc_use_force() {
	use $1 && use !$2 && ewarn "USE=$1 requires $2, $2 will be enabled."
}

# Use when $2 depends strictly on $3
# if use $1 then enable $2 and $3, otherwise disable $2
vlc_use_enable_force() {
	if use $1 ; then
		echo "--enable-$2 --enable-$3"
	else
		echo "--disable-$2"
	fi
}

# Prints the configure argument for the ffmpeg scaling api to use
vlc_ffmpeg_scaling_api() {
	if use ffmpeg ; then
		if has_version ">=media-video/ffmpeg-0.4.9_p20070616-r20" || has_version "=media-video/ffmpeg-0.4.9_p20070616-r2" || has_version "=media-video/ffmpeg-0.4.9_p20070616-r1"; then
			echo "--enable-swscale --disable-imgresample"
		else
			echo "--disable-swscale --enable-imgresample"
		fi
	else
		echo "--disable-swscale --disable-imgresample"
	fi
}

pkg_setup() {
	vlc_use_needs skins truetype
	vlc_use_force skins qt4
	vlc_use_needs cdda cdio
	vlc_use_needs vcdx cdio
	vlc_use_needs bidi truetype
	vlc_use_force remoteosd libgcrypt
	vlc_use_needs fontconfig truetype
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	AT_M4DIR="m4 ${WORKDIR}/${PN}-m4" eautoreconf
}

src_compile () {

	# It would fail if -fforce-addr is used due to too few registers...
	use x86 && filter-flags -fforce-addr

	local MOZILLA_PC

	if use nsplugin; then
		if use seamonkey; then
			MOZILLA_PC=seamonkey-plugin
		else
			if has_version 'net-libs/xulrunner:1.9' ; then
				MOZILLA_PC=libxul
			else
				MOZILLA_PC=xulrunner-plugin
			fi
		fi
	fi

	econf \
		$(use_enable a52) \
		$(use_enable aalib aa) \
		$(use_enable aac faad) \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable arts) \
		--disable-asademux \
		$(use_enable atmo) \
		$(use_enable avahi bonjour) \
		$(use_enable bidi fribidi) \
		$(use_enable cdda) $(use_enable cdda cddax)\
		$(use_enable cddb libcddb) \
		$(use_enable cdio libcdio) \
		--disable-csri \
		$(use_enable dbus) $(use_enable dbus dbus-control) \
		$(use_enable dirac) \
		$(use_enable directfb) \
		$(use_enable dc1394) \
		$(use_enable debug) \
		$(use_enable dts dca) \
		--disable-dv \
		$(use_enable dvb) \
		$(use_enable dvd dvdread) $(use_enable dvd dvdnav) \
		$(use_enable esd) \
		$(use_enable fbcon fb) \
		$(use_enable ffmpeg avcodec) $(use_enable ffmpeg avformat) $(vlc_ffmpeg_scaling_api) $(use_enable ffmpeg postproc) \
		$(use_enable flac) \
		$(use_enable fluidsynth) \
		$(use_enable fontconfig) \
		$(use_enable ggi) \
		$(use_enable gnome gnomevfs) \
		$(use_enable gnutls) \
		$(use_enable hal) \
		$(use_enable httpd) \
		$(use_enable id3tag) \
		$(use_enable jack) \
		$(use_enable kate) \
		$(use_enable libass) \
		$(use_enable libcaca caca) \
		$(use_enable libgcrypt) \
		$(use_enable libnotify notify) \
		--disable-libproxy \
		--disable-libtar \
		$(use_enable lirc) \
		$(use_enable live live555) \
		$(use_enable lua) \
		$(use_enable matroska mkv) \
		$(use_enable mmx) \
		$(use_enable modplug mod) \
		$(use_enable mp3 mad) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable musepack mpc) \
		$(use_enable ncurses) \
		$(use_enable nsplugin mozilla) --with-mozilla-pkg="${MOZILLA_PC}" \
		$(use_enable ogg) \
		$(use_enable opengl glx) $(use_enable opengl) $(use_enable opengl galaktos) \
		$(use_enable optimisememory optimize-memory) \
		$(use_enable oss) \
		$(use_enable png) \
		--disable-portaudio \
		$(use_enable pulseaudio pulse) \
		$(use_enable pvr) \
		$(use_enable qt4) \
		$(use_enable rtsp realrtsp) \
		$(use_enable samba smb) \
		$(use_enable schroedinger) \
		$(use_enable sdl) \
		$(use_enable sdl-image) \
		$(use_enable shout) \
		$(use_enable skins skins2) \
		$(use_enable speex) \
		$(use_enable sse) \
		$(use_enable stream sout) \
		$(use_enable svg) \
		$(use_enable svga svgalib) \
		$(use_enable taglib) \
		$(use_enable theora) \
		$(use_enable truetype freetype) \
		$(use_enable twolame) \
		$(use_enable upnp) \
		$(use_enable v4l) \
		$(use_enable v4l2) \
		$(use_enable vcd) \
		$(use_enable vcdx) \
		$(use_enable vorbis) \
		$(use_enable win32codecs loader) \
		$(use_enable X x11) $(use_enable X screen) \
		$(use_enable x264) \
		$(use_enable xinerama) \
		$(use_enable xml libxml2) \
		$(use_enable xosd) \
		$(use_enable xv xvideo) \
		--disable-xvmc \
		$(use_enable zvbi) \
		--disable-snapshot \
		--disable-growl \
		--disable-optimizations \
		--enable-fast-install \
		$(vlc_use_enable_force vlm vlm sout) \
		$(vlc_use_enable_force skins skins2 qt4) \
		$(vlc_use_enable_force remoteosd remoteosd libgcrypt)

	if [[ $(gcc-major-version) == 2 ]]; then
		sed -i -e s:"-fomit-frame-pointer":: vlc-config || die "-fomit-frame-pointer patching failed"
	fi

	emake || die "make of VLC failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS MAINTAINERS HACKING THANKS NEWS README \
		doc/fortunes.txt doc/intf-cdda.txt doc/intf-vcd.txt

	rm -rf "${D}/usr/share/doc/vlc" \
		"${D}"/usr/share/vlc/vlc{16x16,32x32,48x48,128x128}.{png,xpm,ico}

	if use nsplugin; then
		dodir "/usr/$(get_libdir)/${PLUGINS_DIR}"
		mv "${D}"/usr/$(get_libdir)/mozilla/plugins/* \
			"${D}/usr/$(get_libdir)/${PLUGINS_DIR}/"
	fi

	use skins || rm -rf "${D}/usr/share/vlc/skins2"

	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins "${S}"/share/vlc${res}x${res}.png vlc.png
	done
}
