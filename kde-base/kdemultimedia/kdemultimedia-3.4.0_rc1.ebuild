# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdemultimedia/kdemultimedia-3.4.0_rc1.ebuild,v 1.1 2005/02/27 22:55:51 greg_g Exp $

inherit kde-dist eutils

DESCRIPTION="KDE multimedia apps: noatun, kscd, juk..."

KEYWORDS="~x86 ~amd64 ~sparc"
IUSE="alsa audiofile encode flac gstreamer mad oggvorbis speex theora xine"

DEPEND="~kde-base/kdebase-${PV}
	media-sound/cdparanoia
	audiofile? ( media-libs/audiofile )
	mad? ( media-libs/libmad )
	jack? ( media-sound/jack-audio-connection-kit )
	flac? ( media-libs/flac )
	encode? ( media-sound/lame )
	oggvorbis? ( media-sound/vorbis-tools )
	xine? ( >=media-libs/xine-lib-1_beta12 )
	alsa? ( media-libs/alsa-lib )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora )
	gstreamer? ( >=media-libs/gstreamer-0.8
		     >=media-libs/gst-plugins-0.8 )
	>=media-libs/taglib-1.2
	media-libs/tunepimp"

src_unpack() {
	kde_src_unpack

	epatch "${FILESDIR}/kdemultimedia-3.4.0_beta1-amd64.patch"
}

src_compile() {
	use xine && myconf="${myconf} --with-xine-prefix=/usr"
	use xine || DO_NOT_COMPILE="${DO_NOT_COMPILE} xine_artsplugin"

	myconf="${myconf} --with-cdparanoia --enable-cdparanoia"
	myconf="${myconf} $(use_with alsa arts-alsa) $(use_with alsa)"
	myconf="${myconf} $(use_with oggvorbis vorbis) $(use_with encode lame)"
	myconf="${myconf} $(use_with flac) $(use_with speex)"
	myconf="${myconf} $(use_with mad libmad) $(use_with jack)"

	kde_src_compile
}
