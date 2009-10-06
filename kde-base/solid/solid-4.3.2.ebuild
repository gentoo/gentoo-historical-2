# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid/solid-4.3.2.ebuild,v 1.1 2009/10/06 20:40:18 alexxy Exp $

EAPI="2"

KMNAME="kdebase-workspace"
CPPUNIT_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="Solid: the KDE hardware library"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="bluetooth debug networkmanager wicd"

# solid/CMakeLists.txt has an add_subdirectory statement that depends on
# networkmanager-0.7, referring to a non-existant directory, restricted to =0.6*
# for now.
DEPEND="
	>=sys-apps/hal-0.5.9
	bluetooth? ( net-wireless/bluez )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	wicd? ( net-misc/wicd )
"
RDEPEND="${DEPEND}"

KMEXTRA="
	libs/solid/
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with bluetooth BlueZ)
		$(cmake-utils_use_with networkmanager NetworkManager)
		$(cmake-utils_use_build wicd)
	"

	kde4-meta_src_configure
}

pkg_postinst() {
	elog "If you want to be notified about new plugged devices by a popup,"
	elog "install kde-base/soliduiserver"

	kde4-meta_pkg_postinst
}
