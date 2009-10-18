# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/mplayerthumbs/mplayerthumbs-4.3.1.ebuild,v 1.4 2009/10/18 16:44:40 maekke Exp $

EAPI="2"

KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="A Thumbnail Generator for Video Files on KDE filemanagers."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=41180"
LICENSE="GPL-2"

KEYWORDS="~alpha amd64 ~hppa ~ia64 x86"
IUSE="debug mplayer"

RDEPEND="
	!media-video/mplayerthumbs
	|| (
		>=kde-base/dolphin-${PV}:${SLOT}[kdeprefix=]
		>=kde-base/konqueror-${PV}:${SLOT}[kdeprefix=]
	)
	mplayer? (
		|| (
			media-video/mplayer
			media-video/mplayer-bin
		)
	)
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DENABLE_PHONON_SUPPORT=ON"

	kde4-meta_src_configure
}
