# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/qutecom/qutecom-2.2_p20110210.ebuild,v 1.1 2011/02/13 15:19:23 chithanh Exp $

EAPI="3"

inherit cmake-utils eutils flag-o-matic

DESCRIPTION="Multi-protocol instant messenger and VoIP client"
HOMEPAGE="http://www.qutecom.org/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug oss portaudio xv"

RDEPEND="dev-libs/boost
	dev-libs/glib
	dev-libs/openssl
	alsa? ( media-libs/alsa-lib )
	media-libs/libsamplerate
	media-libs/libsndfile
	portaudio? ( media-libs/portaudio )
	media-libs/speex
	media-video/ffmpeg
	net-im/pidgin[gnutls]
	net-libs/gnutls
	>=net-libs/libosip-3
	>=net-libs/libeXosip-3
	net-misc/curl
	x11-libs/libX11
	x11-libs/qt-gui
	x11-libs/qt-svg
	x11-libs/qt-webkit
	xv? ( x11-libs/libXv )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

pkg_setup() {
	if has_version "<dev-libs/boost-1.41" && has_version ">=dev-libs/boost-1.41"; then
		ewarn "QuteCom build system may mix up headers and libraries if versions of"
		ewarn "dev-libs/boost both before and after 1.41 are installed. If the build"
		ewarn "fails due to undefined boost symbols, remove older boost."
	fi
	# fails to find its libraries with --as-needed, bug #315045
	append-ldflags $(no-as-needed)
}
src_configure() {
	local mycmakeargs="$(cmake-utils_use_enable portaudio PORTAUDIO_SUPPORT)
		$(cmake-utils_use_enable alsa PHAPI_AUDIO_ALSA_SUPPORT)
		$(cmake-utils_use_enable oss PHAPI_AUDIO_OSS_SUPPORT)
		$(cmake-utils_use_enable xv WENGOPHONE_XV_SUPPORT)
		-DLIBPURPLE_INTERNAL=OFF
		-DPORTAUDIO_INTERNAL=OFF
		-DCMAKE_VERBOSE_MAKEFILE=ON "

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	domenu ${PN}/res/${PN}.desktop || die "domenu failed"
	doicon ${PN}/res/${PN}_64x64.png || die "doicon failed"

}
