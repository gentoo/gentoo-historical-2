# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid/solid-4.0.4.ebuild,v 1.1 2008/05/16 00:56:30 ingmar Exp $

EAPI="1"

KMNAME=kdebase-workspace
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="Solid: the KDE hardware library"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth networkmanager test"

# solid/CMakeLists.txt has an add_subdirectory statement that depends on
# networkmanager-0.7, referring to a non-existant directory, restricted to =0.6*
# for now.
DEPEND="
	>=sys-apps/hal-0.5.9
	bluetooth? ( net-wireless/bluez-libs )
	networkmanager? ( =net-misc/networkmanager-0.6* )"
RDEPEND="${DEPEND}"

KMEXTRA="libs/solid/"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with bluetooth BlueZ)
		$(cmake-utils_use_with networkmanager NetworkManager)"

	kde4-meta_src_compile
}

pkg_postinst() {
	elog "If you want to be notified about new plugged devices by a popup,"
	elog "install kde-base/soliduiserver"

	kde4-meta_pkg_postinst
}
