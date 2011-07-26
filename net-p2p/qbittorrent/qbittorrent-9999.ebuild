# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-9999.ebuild,v 1.5 2011/07/26 07:34:14 hwoarang Exp $

EAPI="2"
PYTHON_DEPEND="2"

EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git
http://git.gitorious.org/${PN}/${PN}.git"

inherit python qt4-r2 versionator git-2

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="dbus +X geoip"

QT_MIN="4.6.1"
# boost version so that we always have thread support
CDEPEND="net-libs/rb_libtorrent
	>=x11-libs/qt-core-${QT_MIN}:4
	X? ( >=x11-libs/qt-gui-${QT_MIN}:4 )
	dbus? ( >=x11-libs/qt-dbus-${QT_MIN}:4 )
	dev-libs/boost"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}
	geoip? ( dev-libs/geoip )"

DOCS="AUTHORS Changelog NEWS README TODO"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Respect LDFLAGS
	sed -i -e 's/-Wl,--as-needed/$(LDFLAGS)/g' src/src.pro
	qt4-r2_src_prepare
}

src_configure() {
	local myconf
	use X         || myconf+=" --disable-gui"
	use geoip     || myconf+=" --disable-geoip-database"
	use dbus      || myconf+=" --disable-qt-dbus"

	# slotted boost detection, bug #309415
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.34.1")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	myconf+=" --with-libboost-inc=/usr/include/boost-${BOOST_VER}"

	# econf fails, since this uses qconf
	./configure --prefix=/usr --qtdir=/usr ${myconf} || die "configure failed"
	eqmake4
}
