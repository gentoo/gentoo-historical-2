# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/moc/moc-2.5.0_alpha4.ebuild,v 1.4 2010/05/11 21:23:19 ranger Exp $

EAPI=2
MY_P=${P/_/-}

DESCRIPTION="Music On Console - ncurses interface for playing audio files"
HOMEPAGE="http://moc.daper.net"
SRC_URI="ftp://ftp.daper.net/pub/soft/${PN}/unstable/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ppc64 ~sparc ~x86"
IUSE="oss alsa aac jack mad vorbis flac wavpack sndfile modplug musepack
timidity sid ffmpeg speex libsamplerate curl debug"

RDEPEND=">=sys-libs/db-4
	alsa? ( media-libs/alsa-lib )
	aac? ( media-libs/faad2 )
	jack? ( media-sound/jack-audio-connection-kit )
	mad? ( media-libs/libmad sys-libs/zlib media-libs/libid3tag )
	vorbis? ( >=media-libs/libvorbis-1 )
	flac? ( media-libs/flac )
	wavpack? ( >=media-sound/wavpack-4.31 )
	sndfile? ( >=media-libs/libsndfile-1 )
	modplug? ( >=media-libs/libmodplug-0.7 )
	musepack? ( >=media-sound/musepack-tools-444-r1
		>=media-libs/taglib-1.3.1 )
	timidity? ( media-libs/libtimidity media-sound/timidity++ )
	sid? ( >=media-libs/libsidplay-2 )
	ffmpeg? ( media-video/ffmpeg )
	speex? ( >=media-libs/speex-1 )
	libsamplerate? ( >=media-libs/libsamplerate-0.1 )
	curl? ( >=net-misc/curl-7.12.2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		--without-rcc \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with aac) \
		$(use_with jack) \
		$(use_with mad mp3) \
		$(use_with musepack) \
		$(use_with vorbis) \
		$(use_with flac) \
		$(use_with wavpack) \
		$(use_with sndfile) \
		$(use_with modplug) \
		$(use_with timidity) \
		$(use_with sid sidplay2) \
		$(use_with ffmpeg) \
		$(use_with speex) \
		$(use_with libsamplerate samplerate) \
		$(use_with curl) \
		$(use_enable debug)
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO *.example
	rm -rf "${D}"/usr/share/doc/${PN}
}
