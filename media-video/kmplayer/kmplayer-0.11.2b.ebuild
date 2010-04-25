# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kmplayer/kmplayer-0.11.2b.ebuild,v 1.1 2010/04/25 14:31:14 scarabeus Exp $

EAPI=2
KDE_LINGUAS="cs da de el en_GB es et fr ga gl it ja km ku lt lv mai nb nds nl
nn pl pt pt_BR ro ru sk sv tr uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KMPlayer is a Video player plugin for Konqueror and basic MPlayer/Xine/ffmpeg/ffserver/VDR frontend."
HOMEPAGE="http://kmplayer.kde.org/"
SRC_URI="http://kmplayer.kde.org/pkgs/${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2 LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="cairo debug expat handbook npp"

DEPEND="media-sound/phonon
	expat? ( >=dev-libs/expat-2.0.1 )
	cairo? ( x11-libs/cairo
		x11-libs/pango )
	npp? ( dev-libs/dbus-glib
		>=x11-libs/gtk+-2.10.14:2 )"
RDEPEND="${DEPEND}
	media-video/mplayer"

DOCS="AUTHORS ChangeLog README TODO"

src_prepare() {
	sed -i \
		-e '/add_subdirectory(icons)/d' \
		CMakeLists.txt || die

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs+=(
		$(cmake-utils_use cairo KMPLAYER_BUILT_WITH_CAIRO)
		$(cmake-utils_use expat KMPLAYER_BUILT_WITH_EXPAT)
		$(cmake-utils_use npp KMPLAYER_BUILT_WITH_NPP)
		)

	kde4-base_src_configure
}
