# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/noatun/noatun-3.5_beta1.ebuild,v 1.1 2005/09/22 21:30:59 flameeyes Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE media player"
KEYWORDS="~amd64"
IUSE="xine audiofile"
RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-arts)
$(deprange $PV $MAXKDEVER kde-base/artsplugin-mpeglib)
$(deprange $PV $MAXKDEVER kde-base/artsplugin-mpg123)
	xine? ( $(deprange $PV $MAXKDEVER kde-base/artsplugin-xine) )
	audiofile? ( $(deprange $PV $MAXKDEVER kde-base/artsplugin-audiofile) )"
KMCOPYLIB="
	libartsgui_kde arts/gui/kde/
	libartsgui arts/gui/common/
	libartsmodules arts/modules/"
KMEXTRACTONLY="arts/"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
}