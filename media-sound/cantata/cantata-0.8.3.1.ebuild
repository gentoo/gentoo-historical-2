# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cantata/cantata-0.8.3.1.ebuild,v 1.1 2012/10/27 15:10:23 kensington Exp $

EAPI=4

KDE_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Cantata is a client for the music player daemon (MPD)"
HOMEPAGE="http://kde-apps.org/content/show.php?content=147733"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="kde mtp replaygain"

DEPEND="
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4
	x11-libs/qt-gui:4
	x11-libs/qt-webkit:4
	kde? (
		media-libs/taglib
		media-libs/taglib-extras
	)
	mtp? ( media-libs/libmtp )
	replaygain? (
		media-libs/speex
		media-libs/taglib
		media-libs/taglib-extras
		media-sound/mpg123
		virtual/ffmpeg
	)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep oxygen-icons)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable kde)
		$(cmake-utils_use_enable kde PHONON)
		$(cmake-utils_use_enable replaygain FFMPEG)
		$(cmake-utils_use_enable replaygain MPG123)
		$(cmake-utils_use_enable replaygain SPEEXDSP)
		$(cmake-utils_use_enable mtp)
	)

	# kde fails and to build without taglib
	# taglib is is required to enable replaygain
	if use kde || use replaygain; then
		mycmakeargs+=(
			-DENABLE_TAGLIB=ON
			-DENABLE_TAGLIB_EXTRAS=ON
		)
	fi

	kde4-base_src_configure
}
