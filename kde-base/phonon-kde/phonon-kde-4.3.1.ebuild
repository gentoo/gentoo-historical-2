# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/phonon-kde/phonon-kde-4.3.1.ebuild,v 1.3 2009/10/18 17:46:15 maekke Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
LICENSE="GPL-2"
IUSE="debug pulseaudio +xine"

DEPEND="
	media-libs/alsa-lib
	media-sound/phonon[xine?]
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}
	!kdeprefix? ( !kde-base/phonon-xine[-kdeprefix] )
"

src_prepare() {
	# Don't build tests - they require OpenGL
	sed -e 's/add_subdirectory(tests)//' \
		-i phonon/CMakeLists.txt || die "Failed to disable tests"

	# Disable automagic
	sed -e 's/find_package(Xine)/macro_optional_find_package(Xine)/' \
		-i phonon/kcm/xine/CMakeLists.txt || die "Failed to make xine optional"

	kde4-meta_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with pulseaudio PulseAudio)
		$(cmake-utils_use_with xine)"

	kde4-meta_src_configure
}
