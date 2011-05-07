# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeplasma-addons/kdeplasma-addons-4.6.3.ebuild,v 1.1 2011/05/07 10:48:00 scarabeus Exp $

EAPI=4

WEBKIT_REQUIRED="always"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="Extra Plasma applets and engines."
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="attica debug desktopglobe exif qalculate qwt scim semantic-desktop"

# krunner is only needed to generate dbus interface for lancelot
COMMON_DEPEND="
	app-crypt/qca:2
	app-crypt/qca-ossl:2
	$(add_kdebase_dep kdelibs 'semantic-desktop=')
	$(add_kdebase_dep krunner)
	$(add_kdebase_dep plasma-workspace 'semantic-desktop=')
	x11-misc/shared-mime-info
	attica? ( dev-libs/libattica )
	desktopglobe? ( $(add_kdebase_dep marble) )
	exif? ( $(add_kdebase_dep libkexiv2) )
	qalculate? ( sci-libs/libqalculate )
	qwt? ( x11-libs/qwt:5 )
	scim? ( app-i18n/scim )
	semantic-desktop? (
		$(add_kdebase_dep kdepimlibs 'semantic-desktop')
		$(add_kdebase_dep plasma-workspace 'rss')
	)
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:2
"
# kde-misc/plasmaboard: moved here in 4.3.65
# kde-misc/qalculate-applet: since 4.4.0
RDEPEND="${COMMON_DEPEND}
	!kdeprefix? (
		!kde-misc/plasmaboard
		!kde-misc/qalculate-applet
	)
"

# kdebase-data: some svg icons moved from data directly here.
add_blocker kdebase-data '<4.2.88'

src_configure() {
	mycmakeargs=(
		-DDBUS_INTERFACES_INSTALL_DIR="${EKDEDIR}/share/dbus-1/interfaces/"
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_with desktopglobe Marble)
		$(cmake-utils_use_with exif Kexiv2)
		$(cmake-utils_use_with qalculate)
		$(cmake-utils_use_with qwt)
		$(cmake-utils_use_with semantic-desktop KdepimLibs)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with scim)
	)

	kde4-base_src_configure
}
