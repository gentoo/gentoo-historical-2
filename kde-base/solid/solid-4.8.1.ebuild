# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid/solid-4.8.1.ebuild,v 1.3 2012/03/31 14:01:26 maekke Exp $

EAPI=4

KMNAME="kde-workspace"
CPPUNIT_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="Solid: the KDE hardware library"
KEYWORDS="~amd64 ~arm ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug bluetooth networkmanager wicd"

DEPEND="
	networkmanager? ( net-misc/networkmanager )
	wicd? ( net-misc/wicd )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep solid-runtime)
"

PDEPEND="bluetooth? ( net-wireless/bluedevil )"

KMEXTRA="
	libs/solid/
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with networkmanager NetworkManager)
		$(cmake-utils_use_build wicd)
	)

	kde4-meta_src_configure
}
