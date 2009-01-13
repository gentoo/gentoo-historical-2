# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid/solid-4.1.4.ebuild,v 1.1 2009/01/13 23:32:21 alexxy Exp $

EAPI="2"

KMNAME=kdebase-workspace
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="Solid: the KDE hardware library"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="bluetooth networkmanager test"

DEPEND="
	>=sys-apps/hal-0.5.9
	bluetooth? ( net-wireless/bluez-libs )
	networkmanager? ( net-misc/networkmanager )"
RDEPEND="${DEPEND}"

KMEXTRA="libs/solid/"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with bluetooth BlueZ)
		$(cmake-utils_use_with networkmanager NetworkManager)"

	kde4-meta_src_configure
}

pkg_postinst() {
	elog "If you want to be notified about new plugged devices by a popup,"
	elog "install kde-base/soliduiserver"

	kde4-meta_pkg_postinst
}
