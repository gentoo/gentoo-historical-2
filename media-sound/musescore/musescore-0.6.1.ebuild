# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musescore/musescore-0.6.1.ebuild,v 1.1 2007/07/31 14:05:47 drac Exp $

inherit eutils font toolchain-funcs

MY_P=${P/musescore/mscore}

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="http://mscore.sourceforge.net"
SRC_URI="mirror://sourceforge/mscore/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE="doc jack"

RDEPEND=">=x11-libs/qt-4.3
	media-sound/fluidsynth
	media-libs/alsa-lib
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.6
	dev-util/pkgconfig
	doc? ( virtual/tetex app-doc/doxygen )"

S="${WORKDIR}"/${MY_P}
BUILDDIR="${S}"/build
FONT_SUFFIX="otf"
FONT_S="${S}"/mscore/mscore/fonts

pkg_setup() {
	if ! built_with_use ">=x11-libs/qt-4.3" qt3support; then
		eerror "x11-libs/qt is built without qt3support."
		die "re-emerge x11-libs/qt with USE qt3support."
	fi
}

src_compile() {
	mkdir "${BUILDDIR}"
	cd "${BUILDDIR}"

	cmake \
		-DCMAKE_VERBOSE_MAKEFILE="ON" \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DCMAKE_C_COMPILER="$(type -P $(tc-getCC))" \
		-DCMAKE_CXX_COMPILER="$(type -P $(tc-getCXX))" \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_LD_FLAGS="${LDFLAGS}" \
		../mscore || die "cmake failed."

	emake || die "emake failed."
}

src_install() {
	cd "${BUILDDIR}"
	emake DESTDIR="${D}" install || die "emake install failed."

	font_src_install

	cd "${S}"/mscore
	dodoc ChangeLog NEWS README TODO doc/{MANUAL,README*}

	make_desktop_entry mscore "MuseScore"
}
