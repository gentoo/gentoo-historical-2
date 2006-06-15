# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/juk/juk-3.5.2-r1.ebuild,v 1.11 2006/06/15 00:29:12 carlo Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdemultimedia-3.5-patchset-01.tar.bz2"

DESCRIPTION="Jukebox and music manager for KDE"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE="akode flac gstreamer mp3 vorbis musicbrainz"

DEPEND="media-libs/taglib
	musicbrainz? ( 	media-libs/tunepimp
			media-libs/musicbrainz )
	gstreamer? ( =media-libs/gstreamer-0.8*
	             =media-libs/gst-plugins-0.8* )
	akode? ( media-libs/akode )
	!arts? ( !gstreamer? ( media-libs/akode ) )"

RDEPEND="${DEPEND}
	gstreamer? ( mp3? ( =media-plugins/gst-plugins-mad-0.8* )
		     vorbis? ( =media-plugins/gst-plugins-ogg-0.8*
				  =media-plugins/gst-plugins-vorbis-0.8* )
		     flac? ( =media-plugins/gst-plugins-flac-0.8* ) )"

KMEXTRACTONLY="arts/configure.in.in"

pkg_setup() {
	kde_pkg_setup
	if ! use arts && ! use gstreamer && ! use akode ; then
		ewarn "No audio backend chosen. Defaulting to media-libs/akode."
	fi
}

src_compile() {
	local myconf="$(use_with gstreamer) $(use_with musicbrainz)"

	if ! use arts && ! use gstreamer ; then
		myconf="${myconf} --with-akode"
	else
		if ! use akode ; then
			# work around broken configure
			export include_akode_ffmpeg_FALSE='#'
			export include_akode_mpc_FALSE='#'
			export include_akode_mpeg_FALSE='#'
			export include_akode_xiph_FALSE='#'
		fi
		myconf="${myconf} $(use_with akode)"
	fi

	kde-meta_src_compile
}
