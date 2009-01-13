# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/akonadi/akonadi-4.1.4.ebuild,v 1.1 2009/01/13 21:02:20 alexxy Exp $

EAPI="2"

KMNAME=kdepim
inherit kde4-meta

DESCRIPTION="An extensible cross-desktop storage service for PIM data and meta data"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
# add when libmapi becomes available with an ebuild
#exchange
IUSE="debug +nepomuk +plasma"

# add when libmapi becomes available with an ebuild
#exchange? ( net-libs/libmapi )
RDEPEND="app-misc/strigi[dbus,qt4]
	app-office/akonadi-server
	dev-libs/boost
	dev-libs/libxslt
	>=kde-base/kdemaildir-${PV}:${SLOT}
	>=kde-base/libkdepim-${PV}:${SLOT}
	>=x11-misc/shared-mime-info-0.20
	nepomuk? ( >=kde-base/nepomuk-${PV}:${SLOT} )
	plasma? ( kde-base/libplasma:${SLOT} )"
DEPEND="${RDEPEND}
	dev-libs/libxml2"

KMEXTRACTONLY="libkdepim/
	maildir/"

src_configure() {
	# Set the dbus dirs, otherwise it searches in KDEDIR
	mycmakeargs="${mycmakeargs}
		-DAKONADI_DBUS_INTERFACES_INSTALL_DIR=/usr/share/dbus-1/interfaces
		-DAKONADI_DBUS_SERVICES_INSTALL_DIR=/usr/share/dbus-1/services"
	# replace with $(cmake-utils_use_with exchange OpenChange) when libmapi becomes available with an ebuild
	mycmakeargs="${mycmakeargs}
		-DWITH_LibXslt=ON
		-DWITH_OpenChange=OFF
		$(cmake-utils_use_with nepomuk Nepomuk)
		$(cmake-utils_use_with plasma Plasma)"

	kde4-meta_src_configure
}

src_test() {
	# disable broken test
	sed -i -e '/mailserializerplugintest/ s/^/#DO_NOT_RUN_TEST /' \
		"${S}"/akonadi/plugins/tests/CMakeLists.txt || \
		die "sed to disable mailserializerplugintest failed."

	kde4-meta_src_test
}
