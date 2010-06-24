# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/phonon/phonon-4.3.50_pre20090520.ebuild,v 1.7 2010/06/24 22:24:28 ssuominen Exp $

EAPI="2"

inherit cmake-utils

MY_P="${PN}-4.4_pre20090520"

DESCRIPTION="KDE multimedia API"
HOMEPAGE="http://phonon.kde.org"
SRC_URI="http://dev.gentooexperimental.org/~alexxy/kde/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="arm hppa"
IUSE="debug gstreamer +xcb +xine"

RDEPEND="
	!kde-base/phonon-xine
	!x11-libs/qt-phonon:4
	>=x11-libs/qt-test-4.4.0:4
	>=x11-libs/qt-dbus-4.4.0:4
	>=x11-libs/qt-gui-4.4.0:4
	>=x11-libs/qt-opengl-4.4.0:4
	gstreamer? (
		media-libs/gstreamer
		media-plugins/gst-plugins-meta
	)
	xine? (
		>=media-libs/xine-lib-1.1.15-r1[xcb?]
		xcb? ( x11-libs/libxcb )
	)
"
DEPEND="${RDEPEND}
	>=dev-util/automoc-0.9.87
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use !xine && use !gstreamer; then
		die "you must at least select one backend for phonon"
	fi
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with gstreamer GStreamer)
		$(cmake-utils_use_with gstreamer GStreamerPlugins)
		$(cmake-utils_use_with xine)"

	if use xine; then
		mycmakeargs="${mycmakeargs}
			$(cmake-utils_use_with xcb)"
	else
		sed -i -e '/xine/d' CMakeLists.txt || die "sed failed"
	fi

	cmake-utils_src_configure
}
