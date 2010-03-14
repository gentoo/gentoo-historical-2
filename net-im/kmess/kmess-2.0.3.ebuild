# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kmess/kmess-2.0.3.ebuild,v 1.1 2010/03/14 09:38:21 hwoarang Exp $

EAPI="2"

KDE_MINIMAL="4.2"
KDE_LINGUAS="ar ca da de el es et fi fr hu it ko nb nl pt_BR sk sl sv th tr zh_CN zh_TW"
inherit kde4-base

MY_P="${P/_/}"

DESCRIPTION="KMess is an alternative MSN Messenger chat client for Linux"
HOMEPAGE="http://www.kmess.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug gif konqueror xscreensaver"
RESTRICT="test"

COMMONDEPEND="
	app-crypt/qca:2
	app-crypt/qca-ossl:2
	dev-libs/libxml2
	dev-libs/libxslt
	gif? ( media-libs/giflib )
	konqueror? ( >=kde-base/libkonq-${KDE_MINIMAL} )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
DEPEND="${COMMONDEPEND}
	xscreensaver? ( x11-proto/scrnsaverproto )
"
RDEPEND="${COMMONDEPEND}
	konqueror? ( >=kde-base/konqueror-${KDE_MINIMAL} )
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with gif GIF)
		$(cmake-utils_use_with konqueror LibKonq)
		$(cmake-utils_use_want xscreensaver XSCREENSAVER)"

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	echo
	elog "KMess can use the following optional packages:"
	elog "- www-plugins/adobe-flash 	provides support for winks"
	echo
}
