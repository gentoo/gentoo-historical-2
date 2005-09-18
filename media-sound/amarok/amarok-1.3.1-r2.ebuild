# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-1.3.1-r2.ebuild,v 1.2 2005/09/18 16:11:29 flameeyes Exp $

inherit kde eutils

MY_P=${P/_/-}

DESCRIPTION="amaroK - the audio player for KDE."
HOMEPAGE="http://amarok.kde.org/"
SRC_URI="mirror://sourceforge/amarok/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc -sparc ~x86"
IUSE="arts flac gstreamer kde mp3 mysql noamazon opengl postgres xine xmms
visualization vorbis musicbrainz"
# kde: enables compilation of the konqueror sidebar plugin

S=${WORKDIR}/${MY_P}

DEPEND="kde? ( || ( kde-base/konqueror kde-base/kdebase ) )
	 arts? ( kde-base/arts
		 || ( ( kde-base/kdemultimedia-arts kde-base/akode )
		 	kde-base/kdemultimedia ) )
	 xine? ( >=media-libs/xine-lib-1_rc4 )
	 gstreamer? ( >=media-libs/gstreamer-0.8.8
	              >=media-libs/gst-plugins-0.8.6 )
	 musicbrainz? ( >=media-libs/tunepimp-0.3.0 )
	 >=media-libs/taglib-1.4
	 mysql? ( >=dev-db/mysql-4.0.16 )
	 postgres? ( dev-db/postgresql )
	 opengl? ( virtual/opengl )
	 xmms? ( >=media-sound/xmms-1.2 )
	 visualization? ( media-libs/libsdl
			  >=media-plugins/libvisual-plugins-0.2 )"

RDEPEND="${DEPEND}
	gstreamer? ( mp3? ( >=media-plugins/gst-plugins-mad-0.8.6 )
	             vorbis? ( >=media-plugins/gst-plugins-ogg-0.8.6
	                       >=media-plugins/gst-plugins-vorbis-0.8.6 )
	             flac? ( >=media-plugins/gst-plugins-flac-0.8.6 ) )"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.9.0"

need-kde 3.3

PATCHES="${FILESDIR}/${P}-gst-alsaagain.patch
	${FILESDIR}/${P}-qt-3.3.5.patch"

pkg_setup() {
	if use arts && ! use xine && ! use gstreamer; then
		ewarn "aRts support is deprecated, if you have problems please consider"
		ewarn "enabling support for Xine (preferred) or GStreamer"
		ewarn "(emerge amarok again with USE=\"xine\" or USE=\"gstreamer\")."
		ebeep 2
	fi

	if ! use arts && ! use xine && ! use gstreamer; then
		eerror "amaroK needs either aRts (deprecated), Xine (preferred) or GStreamer to work,"
		eerror "please try again with USE=\"arts\", USE=\"xine\" or USE=\"gstreamer\"."
		die
	fi

	# check whether kdelibs was compiled with arts support
	kde_pkg_setup
}

src_compile() {
	# amarok does not respect kde coding standards, and makes a lot of
	# assuptions regarding its installation directory. For this reason,
	# it must be installed in the KDE install directory.
	PREFIX="${KDEDIR}"

	local myconf="$(use_with arts) $(use_with xine) $(use_with gstreamer)
	              $(use_enable mysql) $(use_enable postgres postgresql)
	              $(use_with opengl) $(use_with xmms)
	              $(use_with visualization libvisual)
	              $(use_enable !noamazon amazon)"

	kde_src_compile
}

src_install() {
	kde_src_install

	# move the desktop file in /usr/share
	dodir /usr/share/applications/kde
	mv ${D}${KDEDIR}/share/applications/kde/amarok.desktop \
		${D}/usr/share/applications/kde/amarok.desktop || die
}

