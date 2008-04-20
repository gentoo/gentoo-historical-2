# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/traverso/traverso-0.42.0.ebuild,v 1.4 2008/04/20 17:42:12 aballier Exp $

inherit eutils qt4 cmake-utils

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"
SRC_URI="http://traverso-daw.org/download/releases/current/${P}.tar.gz"

IUSE="alsa debug jack lame lv2 mad opengl"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="$(qt4_min_version 4.3.1)
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100 )
	>=dev-libs/glib-2.8
	>=media-libs/libsndfile-1.0.12
	media-libs/libsamplerate
	>=sci-libs/fftw-3
	>=media-sound/wavpack-4.40.0
	>=media-libs/libvorbis-1.1.2
	>=media-libs/flac-1.1.2
	lv2? ( media-libs/slv2 )
	mad? ( media-libs/libmad )
	lame? ( media-sound/lame )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if use opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for traverso requires qt4 to be built with opengl support"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-nojack.patch"
	epatch "${FILESDIR}/${P}-strictaliasing.patch"
	epatch "${FILESDIR}/${P}-gcc43.patch"
}

src_compile() {
	local mycmakeargs="$(cmake-utils_use_want jack JACK) $(cmake-utils_use_want alsa ALSA) \
		$(cmake-utils_use_want lv2 LV2) -DUSE_SYSTEM_SLV2_LIBRARY=ON \
		$(cmake-utils_use_want mad MP3_DECODE) $(cmake-utils_use_want lame MP3_ENCODE) \
		$(cmake-utils_use_want opengl OPENGL) $(cmake-utils_use_want debug TRAVERSO_DEBUG)"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README resources/help.text
	doicon resources/freedesktop/icons/128x128/apps/traverso.png
	domenu resources/traverso.desktop
	insinto /usr/share/${PN}
	doins -r resources/themes
}
