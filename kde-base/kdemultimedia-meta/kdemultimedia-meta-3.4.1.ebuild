# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdemultimedia-meta/kdemultimedia-meta-3.4.1.ebuild,v 1.7 2005/07/08 04:15:05 weeve Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.4"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="arts xine"

RDEPEND="arts? ( $(deprange $PV $MAXKDEVER kde-base/artsplugin-audiofile)
		$(deprange $PV $MAXKDEVER kde-base/artsplugin-mpeglib)
		$(deprange $PV $MAXKDEVER kde-base/artsplugin-mpg123)
		xine? ( $(deprange $PV $MAXKDEVER kde-base/artsplugin-xine) )
		$(deprange $PV $MAXKDEVER kde-base/juk)
		$(deprange $PV $MAXKDEVER kde-base/kaboodle)
		$(deprange $PV $MAXKDEVER kde-base/kaudiocreator)
		$(deprange $PV $MAXKDEVER kde-base/akode)
		$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-arts)
		$(deprange $PV $MAXKDEVER kde-base/krec)
		$(deprange $PV $MAXKDEVER kde-base/noatun) )
	$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-kappfinder-data)
	$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-kfile-plugins)
	$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-kioslaves)
	$(deprange $PV $MAXKDEVER kde-base/kmid)
	$(deprange $PV $MAXKDEVER kde-base/kmix)
	$(deprange $PV $MAXKDEVER kde-base/kscd)
	$(deprange $PV $MAXKDEVER kde-base/libkcddb)
	$(deprange $PV $MAXKDEVER kde-base/mpeglib)"
