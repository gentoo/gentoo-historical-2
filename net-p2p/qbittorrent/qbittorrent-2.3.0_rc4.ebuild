# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-2.3.0_rc4.ebuild,v 1.1 2010/07/17 23:18:00 hwoarang Exp $

EAPI="2"
PYTHON_DEPEND="2"

inherit python confutils qt4-r2 versionator

MY_P="${P/_/}"
DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+X geoip libnotify"

# boost version so that we always have thread support
CDEPEND="net-libs/rb_libtorrent
	x11-libs/qt-core:4
	X? ( x11-libs/qt-gui:4
		libnotify? ( x11-libs/qt-gui:4[glib] ) )
	dev-libs/boost"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}
	geoip? ( dev-libs/geoip )
	libnotify? ( x11-libs/libnotify )"

DOCS="AUTHORS Changelog NEWS README TODO"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	confutils_use_depend_all libnotify X
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
	use libnotify || myconf+=" --disable-libnotify"

	# slotted boost detection, bug #309415
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.34.1")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	myconf+=" --with-libboost-inc=/usr/include/boost-${BOOST_VER}"

	# econf fails, since this uses qconf
	./configure --prefix=/usr --qtdir=/usr ${myconf} || die "configure failed"
	eqmake4
}
