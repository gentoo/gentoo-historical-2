# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/phonon/phonon-4.5.1.ebuild,v 1.2 2011/10/28 15:16:55 jmbsvicetto Exp $

EAPI=4

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
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
IUSE="aqua debug +gstreamer pulseaudio vlc xine"

COMMON_DEPEND="
	!x11-libs/qt-phonon:4
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
	xine? ( >=media-libs/phonon-xine-0.4.4 )
"
RDEPEND="${COMMON_DEPEND}
	!kde-base/phonon-xine
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/automoc-0.9.87
	dev-util/pkgconfig
"

REQUIRED_USE="|| ( aqua gstreamer vlc xine )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with pulseaudio GLIB2)
		$(cmake-utils_use_with pulseaudio PulseAudio)
	)
	cmake-utils_src_configure
}
