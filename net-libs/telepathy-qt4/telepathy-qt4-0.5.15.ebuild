# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/telepathy-qt4/telepathy-qt4-0.5.15.ebuild,v 1.1 2011/04/20 12:31:17 scarabeus Exp $

PYTHON_DEPEND="2"

EAPI=3
inherit python base cmake-utils

DESCRIPTION="Qt4 bindings for the Telepathy D-Bus protocol"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug glib farsight"

RDEPEND="
	x11-libs/qt-core:4[glib?]
	x11-libs/qt-dbus:4
	dev-python/dbus-python
	farsight? (
		dev-libs/dbus-glib
		dev-libs/libxml2
		media-libs/gstreamer
		net-libs/telepathy-glib
		net-libs/telepathy-farsight
	)
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/pkgconfig"

PATCHES=(
	"${FILESDIR}/0.5.12_automagicness.patch"
)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable debug DEBUG_OUTPUT)
		$(cmake-utils_use_with glib)
		$(cmake-utils_use_with farsight)
	)
	cmake-utils_src_configure
}
