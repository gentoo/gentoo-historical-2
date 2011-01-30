# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kmess/kmess-2.0.9999.ebuild,v 1.2 2011/01/30 15:12:42 scarabeus Exp $

EAPI=3

EGIT_HAS_SUBMODULES="true"
KDE_LINGUAS="ar ca da de el es et fi fr hu it ko nb nl pt_BR sk sl sv th tr zh_CN zh_TW"
EGIT_REPO_URI="git://gitorious.org/kmess/kmess.git"
EGIT_BRANCH="kmess-2.0.x"

inherit git kde4-base

DESCRIPTION="KMess is an alternative MSN Messenger chat client for Linux"
HOMEPAGE="http://www.kmess.org"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="4"
IUSE="debug gif konqueror xscreensaver"

COMMONDEPEND="
	app-crypt/qca:2
	app-crypt/qca-ossl:2
	dev-libs/libxml2
	dev-libs/libxslt
	gif? ( media-libs/giflib )
	konqueror? ( $(add_kdebase_dep libkonq) )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
DEPEND="${COMMONDEPEND}
	xscreensaver? ( x11-proto/scrnsaverproto )
"
RDEPEND="${COMMONDEPEND}
	!net-im/kmess:0
	konqueror? ( $(add_kdebase_dep konqueror) )
"
RESTRICT="test"

src_unpack() {
	git_src_unpack
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with gif)
		$(cmake-utils_use_with konqueror LibKonq)
		$(cmake-utils_use_want xscreensaver)
	)

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	echo
	elog "KMess can use the following optional packages:"
	elog "- www-plugins/adobe-flash		provides support for winks"
	echo
}
