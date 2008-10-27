# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kmplayer/kmplayer-0.11.0_rc4.ebuild,v 1.1 2008/10/27 18:12:42 scarabeus Exp $

EAPI="2"

NEED_KDE=":4.1"
inherit kde4-base

MY_P="${P/_/-}"
DESCRIPTION="KMPlayer is a Video player plugin for Konqueror and basic MPlayer/Xine/ffmpeg/ffserver/VDR frontend."
HOMEPAGE="http://kmplayer.kde.org/"
SRC_URI="http://${PN}.kde.org/pkgs/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4.1"
IUSE="cairo npp"

DEPEND="
	>=dev-libs/expat-2.0.1
	|| ( media-sound/phonon x11-libs/qt-phonon )
	x11-libs/libXv
	cairo? ( x11-libs/cairo )
	!kdeprefix? ( !media-video/kmplayer:0 )
	npp? ( >=dev-libs/nspr-4.6.7
			x11-libs/gtk+ )
"
RDEPEND="${DEPEND}
	media-video/mplayer"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# fixup icon install
	sed -i \
		-e "s:add_subdirectory(icons):#add_subdirectory(icons):g"\
		CMakeLists.txt || die "removing icons failed"
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=${KDEDIR}
		$(cmake-utils_use_with cairo CAIRO)
		$(cmake-utils_use_with npp NPP)"
	kde4-base_src_configure
}
