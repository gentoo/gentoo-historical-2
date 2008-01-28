# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.9.0_alpha20080128.ebuild,v 1.1 2008/01/28 19:32:32 aballier Exp $

WANT_AUTOMAKE=latest
WANT_AUTOCONF=latest

inherit eutils wxwidgets multilib autotools toolchain-funcs gnome2 nsplugins qt4 flag-o-matic

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-beta/-test}"
MY_P="${PN}-${MY_PV}"
VLC_SNAPSHOT_TIME="0021"

RESTRICT="test"

# Used for live ebuilds
# ESVN_REPO_URI="svn://svn.videolan.org/vlc/trunk"
# ESVN_PROJECT="${PN}-trunk"
# ESVN_BOOTSTRAP="bootstrap"
# ESVN_PATCHES="${WORKDIR}/patches/*.patch"

PATCHLEVEL="45"
M4_TARBALL_VERSION="1"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"
if [[ "${P}" == *_alpha* ]]; then # Snapshots taken from nightlies.videolan.org
	SRC_URI="http://nightlies.videolan.org/build/source/trunk-${PV/*_alpha/}-${VLC_SNAPSHOT_TIME}/${PN}-snapshot-${PV/*_alpha/}.tar.bz2"
	MY_P="${P/_alpha*/}-svn"
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

KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="3dfx a52 aac aalib alsa altivec arts avahi bidi cdda cddb cdio daap dbus dc1394
	debug directfb dts dvb dvd esd fbcon fluidsynth ffmpeg flac ggi gnome gnutls hal httpd
	id3tag jack libcaca libgcrypt libnotify lirc live lua matroska mmx modplug mp3 mpeg
	musepack musicbrainz ncurses nsplugin ogg opengl optimisememory oss png pvr qt4
	rtsp samba sdl sdl-image seamonkey shout skins speex sse stream svg svga taglib
	theora truetype twolame upnp v4l v4l2 vcd vcdx vlm vorbis win32codecs wxwindows
	X x264 xinerama xml xosd xulrunner xv"

RDEPEND="
		sys-libs/zlib
		media-libs/libdvbpsi
		3dfx? ( media-libs/glide-v3 )
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
		daap? ( >=media-libs/libopendaap-0.3.0 )
		dbus? ( >=sys-apps/dbus-1.0.2 )
		dc1394? ( sys-libs/libraw1394
			<media-libs/libdc1394-1.9.99 )
		directfb? ( dev-libs/DirectFB )
		dts? ( media-libs/libdca )
		dvd? (	media-libs/libdvdread
				media-libs/libdvdcss
				>=media-libs/libdvdnav-0.1.9
				media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20050226-r1 )
		flac? ( media-libs/libogg
			>=media-libs/flac-1.1.2 )
		fluidsynth? ( media-sound/fluidsynth )
		ggi? ( media-libs/libggi )
		gnome? ( gnome-base/gnome-vfs )
		gnutls? ( >=net-libs/gnutls-1.3.3 >=dev-libs/libgcrypt-1.2.0 )
		hal? ( sys-apps/hal )
		id3tag? ( media-libs/libid3tag
			sys-libs/zlib )
		jack? ( >=media-sound/jack-audio-connection-kit-0.99.0-r1 )
		libcaca? ( media-libs/libcaca )
		libgcrypt? ( >=dev-libs/libgcrypt-1.2.0 )
		libnotify? ( x11-libs/libnotify )
		lirc? ( app-misc/lirc )
		live? ( >=media-plugins/live-2007.02.20 )
		lua? ( >=dev-lang/lua-5.1 )
		matroska? (
			>=dev-libs/libebml-0.7.6
			>=media-libs/libmatroska-0.8.0 )
		modplug? ( media-libs/libmodplug )
		mp3? ( media-libs/libmad )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		musepack? ( media-libs/libmpcdec )
		musicbrainz? ( =media-libs/musicbrainz-2* )
		ncurses? ( sys-libs/ncurses )
		nsplugin? (
			xulrunner? ( net-libs/xulrunner )
			!xulrunner? ( seamonkey? ( www-client/seamonkey ) )
			!xulrunner? ( !seamonkey? ( www-client/mozilla-firefox ) )
		)
		ogg? ( media-libs/libogg )
		png? ( media-libs/libpng )
		qt4? ( $(qt4_min_version 4.2.0 ) )
		samba? ( net-fs/samba )
		sdl? ( >=media-libs/libsdl-1.2.8
			sdl-image? ( media-libs/sdl-image ) )
		shout? ( media-libs/libshout )
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
		wxwindows? ( =x11-libs/wxGTK-2.6* )
		X? (
			x11-libs/libX11
			x11-libs/libXext
			xv? ( x11-libs/libXv )
			xinerama? ( x11-libs/libXinerama )
			opengl? ( virtual/opengl )
		)
		x264? ( >=media-libs/x264-svn-20061014 )
		xml? ( dev-libs/libxml2 )
		xosd? ( x11-libs/xosd )
		"

# Disabled features and reasons:
# xvmc? ( x11-libs/libXvMC )
#	Will probably compile only on x86
# dirac? ( media-video/dirac )
#	Needs testing but can be ok
# zvbi? ( >=media-libs/zvbi-0.2.25 )
#	Dep not up to date enough

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

pkg_setup() {
	if use wxwindows; then
		WX_GTK_VER="2.6"
		need-wxwidgets unicode || die "You need to install wxGTK with unicode support."
	fi
	vlc_use_needs skins truetype
	vlc_use_needs skins wxwindows
	vlc_use_needs cdda cdio
	vlc_use_needs vcdx cdio
	vlc_use_needs libgcrypt gnutls
	vlc_use_needs bidi truetype
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

	local XPIDL=""
	local MOZILLA_CONFIG=""

	use vlm && \
		myconf="${myconf} --enable-vlm --enable-sout" || \
		myconf="${myconf} --disable-vlm"

	if use nsplugin; then
		if use xulrunner; then
			XPIDL=/usr/$(get_libdir)/xulrunner
			MOZILLA_CONFIG=/usr/bin/xulrunner-config
		elif use seamonkey; then
			XPIDL=/usr/$(get_libdir)/seamonkey
			MOZILLA_CONFIG=/usr/$(get_libdir)/seamonkey/seamonkey-config
		else
			XPIDL=/usr/$(get_libdir)/mozilla-firefox
			MOZILLA_CONFIG=/usr/$(get_libdir)/mozilla-firefox/firefox-config
		fi
	fi

	econf \
		$(use_enable 3dfx glide) \
		$(use_enable a52) \
		$(use_enable aalib aa) \
		$(use_enable aac faad) \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable arts) \
		$(use_enable avahi bonjour) \
		$(use_enable bidi fribidi) \
		$(use_enable cdda) $(use_enable cdda cddax)\
		$(use_enable cddb libcddb) \
		$(use_enable cdio libcdio) \
		$(use_enable daap) \
		$(use_enable dbus) $(use_enable dbus dbus-control) \
		--disable-dirac \
		$(use_enable directfb) \
		$(use_enable dc1394) \
		$(use_enable dts dca) \
		--disable-dv \
		$(use_enable dvb) \
		$(use_enable dvd dvdread) $(use_enable dvd dvdplay) $(use_enable dvd dvdnav) \
		$(use_enable esd) \
		$(use_enable fbcon fb) \
		$(use_enable ffmpeg) \
		$(use_enable flac) \
		$(use_enable fluidsynth) \
		--disable-galaktos \
		$(use_enable ggi) \
		$(use_enable gnome gnomevfs) \
		$(use_enable gnutls) \
		$(use_enable hal) \
		$(use_enable httpd) \
		$(use_enable id3tag) \
		$(use_enable jack) \
		$(use_enable libcaca caca) \
		$(use_enable libgcrypt) \
		$(use_enable libnotify notify) \
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
		$(use_enable musicbrainz) \
		$(use_enable ncurses) \
		$(use_enable nsplugin mozilla) XPIDL="${XPIDL}" MOZILLA_CONFIG="${MOZILLA_CONFIG}" \
		$(use_enable ogg) \
		$(use_enable opengl glx) $(use_enable opengl) \
		$(use_enable optimisememory optimize-memory) \
		$(use_enable oss) \
		$(use_enable png) \
		--disable-portaudio \
		$(use_enable pvr) \
		$(use_enable qt4) \
		$(use_enable rtsp) $(use_enable rtsp realrtsp) \
		$(use_enable samba smb) \
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
		$(use_enable wxwindows wxwidgets) WX_CONFIG="${WX_CONFIG}" \
		$(use_enable X x11) $(use_enable X screen) \
		$(use_enable x264) \
		$(use_enable xinerama) \
		$(use_enable xml libxml2) \
		$(use_enable xosd) \
		$(use_enable xv xvideo) \
		--disable-xvmc \
		--disable-zvbi \
		--disable-libvc1 \
		--disable-snapshot \
		--disable-growl \
		--disable-optimizations \
		--enable-utf8 \
		--enable-libtool \
		--enable-fast-install \
		${myconf} || die "configuration failed"

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
