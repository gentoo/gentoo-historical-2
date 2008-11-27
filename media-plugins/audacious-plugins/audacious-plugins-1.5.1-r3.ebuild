# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/audacious-plugins/audacious-plugins-1.5.1-r3.ebuild,v 1.4 2008/11/27 22:01:31 jer Exp $

inherit eutils flag-o-matic autotools

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.atheme.org/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="aac adplug alsa arts chardet esd flac gnome jack lirc modplug mp3 mtp musepack nls oss pulseaudio scrobbler sdl sid sndfile sse2 timidity tta vorbis wavpack wma"

RDEPEND="app-arch/unzip
	>=dev-libs/libcdio-0.79-r1
	>=dev-libs/dbus-glib-0.60
	dev-libs/libxml2
	>=gnome-base/libglade-2.3.1
	>=media-libs/libcddb-1.2.1
	>=media-sound/audacious-1.5.1-r1
	>=net-misc/neon-0.26.4
	>=x11-libs/gtk+-2.10
	adplug? ( >=dev-cpp/libbinio-1.4 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	arts? ( kde-base/arts )
	esd? ( >=media-sound/esound-0.2.38-r1 )
	flac? ( >=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1 )
	jack? ( >=media-libs/bio2jack-0.4
		media-sound/jack-audio-connection-kit )
	lirc? ( app-misc/lirc )
	mp3? ( media-libs/libmad )
	mtp? ( media-libs/libmtp )
	musepack? ( media-libs/libmpcdec media-libs/taglib )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
	scrobbler? ( net-misc/curl
		     media-libs/musicbrainz )
	sdl? (	>=media-libs/libsdl-1.2.5 )
	sid? ( media-libs/libsidplay )
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

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Bug 232418; patch by Ivan Iraci <ivanhoe@vfemail.net>
	epatch "${FILESDIR}/${PV}-missing-include.patch"
	# Bug 230995; patch by Linus Walleij
	# http://bugzilla.atheme.org/show_bug.cgi?id=35
	# Rebased from hg head to 1.5.1
	epatch "${FILESDIR}/${PV}-libmtp-0.3.0-API.patch"
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	mp3_warning

	econf \
		--enable-cdaudio \
		--enable-dbus \
		--enable-neon \
		--disable-projectm \
		--disable-projectm-1.0 \
		--disable-rootvis \
		$(use_enable aac) \
		$(use_enable adplug) \
		$(use_enable alsa) \
		$(use_enable arts) \
		$(use_enable chardet) \
		$(use_enable esd) \
		$(use_enable flac flacng) \
		$(use_enable flac filewriter_flac) \
		$(use_enable jack) \
		$(use_enable gnome gnomeshortcuts) \
		$(use_enable lirc) \
		$(use_enable mp3) \
		$(use_enable modplug) \
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
		$(use_enable wavpack) \
		$(use_enable wma) \
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
