# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/juk/juk-3.4.0_beta1.ebuild,v 1.2 2005/01/17 09:13:52 danarmak Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Jukebox and music manager for KDE"
KEYWORDS="~x86"
IUSE="gstreamer"
DEPEND="media-libs/taglib
	media-libs/tunepimp
	!media-sound/juk
	gstreamer? ( >=media-libs/gstreamer-0.8 >=media-libs/gst-plugins-0.8 )"
KMEXTRACTONLY="arts/configure.in.in"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
}