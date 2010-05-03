# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid/solid-4.4.2.ebuild,v 1.2 2010/05/03 07:07:31 aballier Exp $

EAPI="3"

KMNAME="kdebase-workspace"
CPPUNIT_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="Solid: the KDE hardware library"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="bluetooth debug networkmanager wicd"

# solid/CMakeLists.txt has an add_subdirectory statement that depends on
# networkmanager-0.7, referring to a non-existant directory, restricted to =0.6*
# for now.
DEPEND="
	bluetooth? ( net-wireless/bluez )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	wicd? ( net-misc/wicd )
"
RDEPEND="${DEPEND}"

KMEXTRA="
	libs/solid/
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.1-darwin-compile-powermanager.patch
)

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with bluetooth BlueZ)
		$(cmake-utils_use_with networkmanager NetworkManager)
		$(cmake-utils_use_build wicd)
	)

	kde4-meta_src_configure
}
