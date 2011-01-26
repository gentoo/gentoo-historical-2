# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid/solid-4.6.0.ebuild,v 1.1 2011/01/26 20:28:57 alexxy Exp $

EAPI="3"

KMNAME="kdebase-workspace"
CPPUNIT_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="Solid: the KDE hardware library"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug networkmanager wicd"

# solid/CMakeLists.txt has an add_subdirectory statement that depends on
# networkmanager-0.7, referring to a non-existant directory, restricted to =0.6*
# for now.
DEPEND="
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	wicd? ( net-misc/wicd )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep solid-runtime)
"

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
