# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/audacious-plugins/audacious-plugins-2.1_alpha2.ebuild,v 1.1 2009/06/23 22:22:43 chainsaw Exp $

inherit eutils flag-o-matic

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.atheme.org/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="adplug alsa bs2b cdaudio esd flac gnome icecast ipv6 jack lirc mp3 mtp musepack
nls oss projectm pulseaudio scrobbler sdl sid sndfile sse2 timidity tta vorbis wavpack wma"

RDEPEND="app-arch/unzip
	>=dev-libs/dbus-glib-0.60
	dev-libs/libxml2
	>=media-sound/audacious-2.1_alpha2
	>=net-misc/neon-0.26.4
	>=x11-libs/gtk+-2.14
	adplug? ( >=dev-cpp/libbinio-1.4 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	bs2b? ( media-libs/libbs2b )
	cdaudio? ( >=media-libs/libcddb-1.2.1
		>=dev-libs/libcdio-0.79-r1 )
	esd? ( >=media-sound/esound-0.2.38-r1 )
	flac? ( >=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1 )
	jack? ( >=media-libs/bio2jack-0.4
		media-sound/jack-audio-connection-kit )
	lirc? ( app-misc/lirc )
	mp3? ( media-libs/libmad )
	mtp? ( media-libs/libmtp )
	musepack? ( media-libs/libmpcdec media-libs/taglib )
	projectm? ( >=media-libs/libprojectm-1.2.0
		>=media-libs/libsdl-1.2.5 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
	scrobbler? ( net-misc/curl )
	sdl? (	>=media-libs/libsdl-1.2.5 )
	sid? ( >=media-libs/libsidplay-2.1.1-r2 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	timidity? ( media-sound/timidity++ )
	tta? ( media-libs/libid3tag )
	vorbis? ( >=media-libs/libvorbis-1.2.0
		  >=media-libs/libogg-1.1.3 )
	wavpack? ( >=media-sound/wavpack-4.41.0 )
	wma? ( >=media-libs/libmms-0.3 )"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )
	>=dev-util/pkgconfig-0.9.0"

mp3_warning() {
	if ! useq mp3 ; then
		ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
	fi
}

src_compile() {
	# This is masked in the portage tree, so I'll save you the
	# popup. Be good, bugs go upstream and we like patches.
	append-flags -DNOT_ALPHA_RELEASE

	mp3_warning

	econf \
		--enable-aac \
		--enable-chardet \
		--enable-dbus \
		--enable-modplug \
		--enable-neon \
		--disable-coreaudio \
		--disable-dockalbumart \
		--disable-projectm \
		$(use_enable projectm projectm-1.0) \
		$(use_enable adplug) \
		$(use_enable alsa) \
		$(use_enable alsa bluetooth) \
		$(use_enable bs2b) \
		$(use_enable cdaudio) \
		$(use_enable esd) \
		$(use_enable flac flacng) \
		$(use_enable flac filewriter_flac) \
		$(use_enable ipv6) \
		$(use_enable jack) \
		$(use_enable gnome gnomeshortcuts) \
		$(use_enable lirc) \
		$(use_enable mp3) \
		$(use_enable musepack) \
		$(use_enable mtp mtp_up) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable pulseaudio pulse) \
		$(use_enable sdl paranormal) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable sse2) \
		$(use_enable timidity) \
		$(use_enable tta) \
		$(use_enable vorbis) \
		$(use_enable vorbis filewriter_vorbis) \
		$(use_enable wavpack) \
		$(use_enable wma) \
		$(use_enable wma mms) \
		|| die

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS
}

pkg_postinst() {
	mp3_warning
}
