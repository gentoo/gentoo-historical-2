# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeplasma-addons/kdeplasma-addons-4.11.0.ebuild,v 1.1 2013/08/14 20:23:53 dilfridge Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Extra Plasma applets and engines"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="attica debug desktopglobe exif fcitx ibus json oauth qalculate qwt scim"

RESTRICT=test
# tests hang

# krunner is only needed to generate dbus interface for lancelot
COMMON_DEPEND="
	app-crypt/qca:2
	app-crypt/qca-ossl:2
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep krunner)
	$(add_kdebase_dep plasma-workspace)
	x11-misc/shared-mime-info
	attica? ( dev-libs/libattica )
	desktopglobe? ( $(add_kdebase_dep marble) )
	exif? ( $(add_kdebase_dep libkexiv2) )
	fcitx? ( app-i18n/fcitx[dbus(+)] )
	ibus? ( app-i18n/ibus )
	json? ( dev-libs/qjson )
	oauth? ( dev-libs/qoauth )
	qalculate? ( sci-libs/libqalculate )
	qwt? ( x11-libs/qwt:5 )
	scim? ( app-i18n/scim )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:2
"
RDEPEND="${COMMON_DEPEND}
"

src_configure() {
	mycmakeargs=(
		-DDBUS_INTERFACES_INSTALL_DIR="${EPREFIX}/usr/share/dbus-1/interfaces/"
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_with desktopglobe Marble)
		$(cmake-utils_use_with exif Kexiv2)
		$(cmake-utils_use_build ibus)
		$(cmake-utils_use_with json QJSON)
		$(cmake-utils_use_with oauth QtOAuth)
		$(cmake-utils_use_with qalculate)
		$(cmake-utils_use_with qwt)
		$(cmake-utils_use_build scim)
	)

	kde4-base_src_configure
}
