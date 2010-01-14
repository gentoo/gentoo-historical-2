# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/mplayerthumbs/mplayerthumbs-4.3.3.ebuild,v 1.6 2010/01/14 00:33:40 jer Exp $

EAPI="2"

KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="A Thumbnail Generator for Video Files on KDE filemanagers."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=41180"
LICENSE="GPL-2"

KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="debug mplayer"

RDEPEND="
	!media-video/mplayerthumbs
	|| (
		$(add_kdebase_dep dolphin)
		$(add_kdebase_dep konqueror)
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
