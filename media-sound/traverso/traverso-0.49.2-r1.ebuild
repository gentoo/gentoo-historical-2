# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/traverso/traverso-0.49.2-r1.ebuild,v 1.2 2012/06/27 19:35:01 ssuominen Exp $

EAPI=4
inherit cmake-utils eutils gnome2-utils

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"
SRC_URI="http://traverso-daw.org/download/releases/current/${P}.tar.gz"

IUSE="alsa debug jack lame lv2 mad pulseaudio"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9 )
	>=media-libs/libsndfile-1.0.12
	media-libs/libsamplerate
	>=sci-libs/fftw-3
	>=media-sound/wavpack-4.40.0
	>=media-libs/libogg-1.1.2
	>=media-libs/libvorbis-1.1.2
	>=media-libs/flac-1.1.2
	lv2? ( >=media-libs/slv2-0.6.1 )
	mad? ( >=media-libs/libmad-0.15.0 )
	lame? ( media-sound/lame )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README resources/help.text )

PATCHES=(
	"${FILESDIR}"/${PN}-0.49.1-slv2.patch
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-gold.patch
	"${FILESDIR}"/${P}-gcc47.patch
	)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_want jack JACK) $(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want pulseaudio PULSEAUDIO)
		$(cmake-utils_use_want lv2 LV2) -DUSE_SYSTEM_SLV2_LIBRARY=ON
		$(cmake-utils_use_want mad MP3_DECODE) $(cmake-utils_use_want lame MP3_ENCODE)
		$(cmake-utils_use_want debug TRAVERSO_DEBUG)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local res
	for res in 16 24 48 64 128; do
		doicon -s ${res} resources/freedesktop/icons/${res}x${res}/apps/${PN}.png
	done
	doicon -s scalable resources/freedesktop/icons/scalable/apps/${PN}.svg

	domenu resources/traverso.desktop

	insinto /usr/share/${PN}
	doins -r resources/themes
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
