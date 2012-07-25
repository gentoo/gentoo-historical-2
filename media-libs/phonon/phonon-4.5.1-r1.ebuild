# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/phonon/phonon-4.5.1-r1.ebuild,v 1.9 2012/07/25 21:18:57 maekke Exp $

EAPI=4

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 ~arm hppa ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
else
	SCM_ECLASS="git-2"
	EGIT_REPO_URI="git://anongit.kde.org/${PN}"
	KEYWORDS=""
fi

inherit cmake-utils ${SCM_ECLASS}

DESCRIPTION="KDE multimedia API"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/phonon"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="aqua debug +gstreamer pulseaudio vlc"

COMMON_DEPEND="
	!!x11-libs/qt-phonon:4
	>=x11-libs/qt-core-4.6.0:4
	>=x11-libs/qt-dbus-4.6.0:4
	>=x11-libs/qt-gui-4.6.0:4
	>=x11-libs/qt-test-4.6.0:4
	pulseaudio? (
		dev-libs/glib:2
		>=media-sound/pulseaudio-0.9.21[glib]
	)
"
# directshow? ( media-sound/phonon-directshow )
# mmf? ( media-sound/phonon-mmf )
# mplayer? ( media-sound/phonon-mplayer )
# waveout? ( media-sound/phonon-waveout )
PDEPEND="
	aqua? ( media-libs/phonon-qt7 )
	gstreamer? ( media-libs/phonon-gstreamer )
	vlc? ( >=media-libs/phonon-vlc-0.3.2 )
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	>=dev-util/automoc-0.9.87
	virtual/pkgconfig
"

REQUIRED_USE="|| ( aqua gstreamer vlc )"

PATCHES=( "${FILESDIR}/${P}-qmakeworkaround.patch" )

src_configure() {
	local mycmakeargs=(
		-DWITH_QZeitgeist=OFF
		$(cmake-utils_use_with pulseaudio GLIB2)
		$(cmake-utils_use_with pulseaudio PulseAudio)
	)

	cmake-utils_src_configure
}
