# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kradio/kradio-4.0.0.ebuild,v 1.1 2009/06/02 10:43:55 scarabeus Exp $

EAPI="2"

KDE_LINGUAS="cs de es pl pt ru uk"
inherit kde4-base

MY_P="${PN}4-${PV/_/-}"

DESCRIPTION="kradio is a radio tuner application for KDE"
HOMEPAGE="http://kradio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="alsa debug encode ffmpeg lirc +mp3 +vorbis v4l2"

DEPEND="
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	lirc? ( app-misc/lirc )
	mp3? ( media-sound/lame )
	vorbis? (
		media-libs/libvorbis
		media-libs/libogg
	)
	ffmpeg? (
		>=media-libs/libmms-0.4
		>=media-video/ffmpeg-0.5
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs="$(cmake-utils_use_with alsa ALSA)
		$(cmake-utils_use_with mp3 LAME)
		$(cmake-utils_use_with vorbis OGG_VORBIS)
		$(cmake-utils_use_with lirc LIRC)
		$(cmake-utils_use_with ffmpeg FFMPEG)
		$(cmake-utils_use_with v4l2 V4L2)"

	kde4-base_src_configure
}
