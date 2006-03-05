# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-1.4_beta2-r1.ebuild,v 1.1 2006/03/05 20:44:11 flameeyes Exp $

LANGS="az bg br ca cs cy da de el en_GB es et fi fr ga gl he hi hu is it ja ko
lt nb nl nn pa pl pt pt_BR ro ru rw sl sr sr@Latn sv ta tg th tr uk uz xx zh_CN
zh_TW"
LANGS_DOC="da de es et fr it nl pt pt_BR ru sv"

USE_KEG_PACKAGING=1

inherit kde eutils flag-o-matic

MY_P="${P/_rc/_RC}"
MY_P="${MY_P/_beta/-beta}"
S="${WORKDIR}/${MY_P/_RC*//}"

DESCRIPTION="amaroK - the audio player for KDE."
HOMEPAGE="http://amarok.kde.org/"
SRC_URI="mirror://sourceforge/amarok/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="aac arts exscalibar flac gstreamer kde mysql noamazon opengl postgres xine xmms
visualization musicbrainz ipod akode real"
# kde: enables compilation of the konqueror sidebar plugin

DEPEND="kde? ( || ( kde-base/konqueror kde-base/kdebase )
		|| ( kde-base/kdemultimedia-kioslaves kde-base/kdemultimedia ) )
	arts? ( kde-base/arts
	        || ( kde-base/kdemultimedia-arts kde-base/kdemultimedia ) )
	xine? ( >=media-libs/xine-lib-1_rc4 )
	gstreamer? ( =media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-base-0.10* )
	musicbrainz? ( >=media-libs/tunepimp-0.3 )
	>=media-libs/taglib-1.4
	mysql? ( >=dev-db/mysql-4.0.16 )
	postgres? ( dev-db/postgresql )
	opengl? ( virtual/opengl )
	xmms? ( >=media-sound/xmms-1.2 )
	visualization? ( media-libs/libsdl
	                 >=media-plugins/libvisual-plugins-0.2 )
	ipod? ( media-libs/libgpod )
	akode? ( media-libs/akode )
	aac? ( media-libs/libmp4v2 )
	exscalibar? ( media-libs/exscalibar )
	real? ( media-video/realplayer )"

RDEPEND="${DEPEND}
	dev-lang/ruby"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.9.0"

need-kde 3.3

pkg_setup() {
	if ! use xine && ! use gstreamer && ! use akode && ! use real; then
		eerror "amaroK needs either aRts (deprecated), Xine (preferred) or GStreamer to work,"
		eerror "please try again enabling at least one of akode, xine, gstreamer or real"
		eerror "useflags."
		die
	fi

	# check whether kdelibs was compiled with arts support
	kde_pkg_setup

	append-flags -fno-inline
}

src_compile() {
	# Extra, unsupported engines are forcefully disabled.
	local myconf="$(use_with arts) $(use_with xine)
				  $(use_with gstreamer gstreamer10)
	              $(use_enable mysql) $(use_enable postgres postgresql)
	              $(use_with opengl) $(use_with xmms)
	              $(use_with visualization libvisual)
	              $(use_enable !noamazon amazon)
	              $(use_with musicbrainz)
	              $(use_with exscalibar)
				  $(use_with ipod libgpod)
				  $(use_with akode)
				  $(use_with aac mp4v2)
				  $(use_with real helix)
	              --without-mas
	              --without-nmm
				  --without-ifp"

	kde_src_compile
}

