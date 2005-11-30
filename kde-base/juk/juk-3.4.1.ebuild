# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/juk/juk-3.4.1.ebuild,v 1.1 2005/05/25 21:23:00 danarmak Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Jukebox and music manager for KDE"
KEYWORDS="~x86 ~amd64"
IUSE="flac gstreamer mad oggvorbis"

DEPEND="media-libs/taglib
	media-libs/tunepimp
	gstreamer? ( >=media-libs/gstreamer-0.8 )
	$(deprange $PV $MAXKDEVER kde-base/akode)"

RDEPEND="${DEPEND}
	gstreamer? ( >=media-libs/gst-plugins-0.8
		     mad? ( >=media-plugins/gst-plugins-mad-0.8 )
		     oggvorbis? ( >=media-plugins/gst-plugins-ogg-0.8
				  >=media-plugins/gst-plugins-vorbis-0.8 )
		     flac? ( >=media-plugins/gst-plugins-flac-0.8 ) )"

KMCOPYLIB="
	libakode akode/lib/"
KMEXTRACTONLY="arts/configure.in.in
	akode/lib/"

pkg_setup() {
	if ! useq arts && ! useq gstreamer; then
		eerror "${PN} needs USE=\"arts\" (and kdelibs compiled with USE=\"arts\") or USE=\"gstreamer\""
		die
	fi
}
