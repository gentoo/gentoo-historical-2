# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/allegro/allegro-4.4.1.1.ebuild,v 1.2 2010/03/16 14:29:36 ssuominen Exp $

EAPI=2
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils eutils

DESCRIPTION="cross-platform multimedia library"
HOMEPAGE="http://alleg.sourceforge.net/"
SRC_URI="mirror://sourceforge/alleg/${P}.tar.gz"

LICENSE="Allegro as-is GPL-2 ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa fbcon jack jpeg opengl oss png svga test +tools vga vorbis X"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( >=media-libs/jpeg-6b )
	png? ( >=media-libs/libpng-1.2 )
	svga? ( media-libs/svgalib )
	vorbis? ( media-libs/libvorbis )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXt
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
		opengl? ( virtual/opengl
			virtual/glu )
	)
	!media-libs/allegrogl
	!media-libs/jpgalleg"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	X? (
		x11-proto/xextproto
		x11-proto/xf86dgaproto
		x11-proto/xf86vidmodeproto
		x11-proto/xproto
	)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-shared.patch \
		"${FILESDIR}"/${P}-optional_drivers.patch

	# loadpng.h is too common for /usr/include, see src_install
	sed -i \
		-e 's:-I${includedir}:-I${includedir}/loadpng:' \
		misc/loadpng.pc.in || die

	sed -i \
		-e "s:allegro-\${ALLEGRO_VERSION}:${PF}:" \
		docs/CMakeLists.txt || die
}

src_configure() {
	# WANT_LINUX_CONSOLE is by default OFF
	# WANT_EXAMPLES doesn't install anything

	mycmakeargs=(
		"-DDOCDIR=share/doc"
		"-DINFODIR=share/info"
		"-DMANDIR=share/man"
		$(cmake-utils_use_want alsa)
		"-DWANT_EXAMPLES=OFF"
		$(cmake-utils_use_want jack)
		$(cmake-utils_use_want jpeg JPGALLEG)
		"-DWANT_LINUX_CONSOLE=OFF"
		$(cmake-utils_use_want fbcon LINUX_FBCON)
		$(cmake-utils_use_want svga LINUX_SVGALIB)
		$(cmake-utils_use_want vga LINUX_VGA)
		$(cmake-utils_use_want png LOADPNG)
		$(cmake-utils_use_want vorbis LOGG)
		$(cmake-utils_use_want oss)
		$(cmake-utils_use_want test TESTS)
		$(cmake-utils_use_want tools)
		$(cmake-utils_use_want X X11)
		)

	if use X; then
		mycmakeargs+=(
			$(cmake-utils_use_want opengl ALLEGROGL)
			)
	else
		mycmakeargs+=(
			"-DWANT_ALLEGROGL=OFF"
			)
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dohtml docs/html/*.html || die
	doman docs/man/*.3 || die

	if use png; then
		dodir /usr/include/loadpng
		mv -vf "${D}"/usr/include/loadpng.h "${D}"/usr/include/loadpng || die
	fi
}
