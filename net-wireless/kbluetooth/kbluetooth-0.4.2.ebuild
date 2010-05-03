# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/kbluetooth/kbluetooth-0.4.2.ebuild,v 1.2 2010/05/03 18:07:15 ssuominen Exp $

EAPI=2
KDE_LINGUAS="cs da de en_GB eo es et fr ga gl it km lt nds nl pa pt pt_BR ro
ru sv tr uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="Bluetooth utils for KDE4"
HOMEPAGE="http://techbase.kde.org/Kbluetooth"
SRC_URI="http://kde-apps.org/CONTENT/content-files/112110-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~x86"
IUSE="debug semantic-desktop"

COMMON_DEPEND=">=kde-base/solid-${KDE_MINIMAL}[bluetooth]
	>=kde-base/libkworkspace-${KDE_MINIMAL}
	|| ( >=kde-base/kdelibs-4.4.0 =kde-base/libknotificationitem-4.3* )
	>=kde-base/kdelibs-${KDE_MINIMAL}[semantic-desktop?]"
RDEPEND="${COMMON_DEPEND}
	app-mobilephone/obex-data-server
	app-mobilephone/obexftp"
DEPEND="${COMMON_DEPEND}"

DOCS="AUTHORS ChangeLog TODO"

src_prepare() {
	sed -i \
		-e 's:${KDE4WORKSPACE_SOLIDCONTROL_LIBRARY}:solidcontrol:g' \
		src/{,device-manager/,inputwizard/}CMakeLists.txt || die

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs+=(
		$(cmake-utils_use_with semantic-desktop Nepomuk)
	)

	kde4-base_src_configure
}
