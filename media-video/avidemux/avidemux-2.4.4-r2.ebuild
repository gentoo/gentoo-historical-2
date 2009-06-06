# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.4.4-r2.ebuild,v 1.2 2009/06/06 20:35:38 nixnut Exp $

EAPI="2"

inherit cmake-utils eutils flag-o-matic

MY_P=${PN}_${PV}

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ppc ~x86"
IUSE="+aac +aften +alsa amrnb +dts esd jack libsamplerate +mp3 +truetype
	+vorbis +x264 +xv +xvid gtk +qt4"
RESTRICT="test"

RDEPEND="dev-libs/libxml2
	media-libs/libpng
	media-libs/libsdl
	dev-libs/glib:2
	aac? ( media-libs/faac
		media-libs/faad2 )
	aften? ( media-libs/aften )
	alsa? ( media-libs/alsa-lib )
	amrnb? ( media-libs/amrnb )
	dts? ( media-libs/libdca )
	mp3? ( media-sound/lame )
	esd? ( media-sound/esound )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	truetype? ( media-libs/freetype
		media-libs/fontconfig )
	vorbis? ( media-libs/libvorbis )
	x264? ( media-libs/x264 )
	xv? ( x11-libs/libXv )
	xvid? ( media-libs/xvid )
	gtk? ( x11-libs/gtk+:2 )
	qt4? ( >=x11-libs/qt-gui-4.5.1:4 )
	x11-libs/libX11"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	dev-util/cmake"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/lavcodec-mpegvideo_mmx-asm-fix.patch
	epatch "${FILESDIR}"/${PN}-2.4-cmake264.patch  # bug 268618
	epatch "${FILESDIR}"/${PN}-2.4-i18n.patch      # bug 272258
	epatch "${FILESDIR}"/${P}-gcc-4.4.patch        # bug 269114
}

src_configure() {
	# Commented out options cause compilation errors, some
	# might need -Wl,--as-needed in LDFLAGS and all USE
	# flags disabled for reproducing. -drac
	# TODO. Needs to be fixed, or reported upstream.

	local mycmakeargs

	# ConfigureChecks.cmake
	use alsa || mycmakeargs="${mycmakeargs} -DNO_ALSA=1"
	#use oss || mycmakeargs="${mycmakeargs} -DNO_OSS=1"
	#use nls || mycmakeargs="${mycmakeargs} -DNO_NLS=1"
	#use sdl || mycmakeargs="${mycmakeargs} -DNO_SDL=1"

	# ConfigureChecks.cmake -> ADM_CHECK_HL -> cmake/adm_checkHeaderLib.cmake
	use truetype || mycmakeargs="${mycmakeargs} -DNO_FontConfig=1"
	use xv || mycmakeargs="${mycmakeargs} -DNO_Xvideo=1"
	use esd || mycmakeargs="${mycmakeargs} -DNO_Esd=1"
	use jack || mycmakeargs="${mycmakeargs} -DNO_Jack=1"
	use aften || mycmakeargs="${mycmakeargs} -DNO_Aften=1"
	use libsamplerate || mycmakeargs="${mycmakeargs} -DNO_libsamplerate=1"
	use aac || mycmakeargs="${mycmakeargs} -DNO_FAAC=1"
	use mp3 || mycmakeargs="${mycmakeargs} -DNO_Lame=1"
	use xvid || mycmakeargs="${mycmakeargs} -DNO_Xvid=1"
	use amrnb || mycmakeargs="${mycmakeargs} -DNO_AMRNB=1"
	use dts || mycmakeargs="${mycmakeargs} -DNO_libdca=1"
	use x264 || mycmakeargs="${mycmakeargs} -DNO_x264=1"
	use aac || mycmakeargs="${mycmakeargs} -DNO_FAAD=1 -DNO_NeAAC=1"
	use vorbis || mycmakeargs="${mycmakeargs} -DNO_Vorbis=1"

	# CMakeLists.txt
	use truetype || mycmakeargs="${mycmakeargs} -DNO_FREETYPE=1"
	use gtk || mycmakeargs="${mycmakeargs} -DNO_GTK=1"
	use qt4 || mycmakeargs="${mycmakeargs} -DNO_QT4=1"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS History
	doicon avidemux_icon.png

	use gtk && make_desktop_entry avidemux2_gtk "Avidemux GTK" \
		avidemux_icon "AudioVideo;GTK"
	use qt4 && make_desktop_entry avidemux2_qt4 "Avidemux Qt" \
		avidemux_icon "AudioVideo;Qt"
}
