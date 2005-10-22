# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-meta/kdesdk-meta-3.5_beta1.ebuild,v 1.2 2005/10/22 06:52:28 halcy0n Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdesdk - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~amd64 ~x86"
IUSE="subversion"

RDEPEND="
	$(deprange $PV $MAXKDEVER kde-base/cervisia)
	$(deprange $PV $MAXKDEVER kde-base/kapptemplate)
	$(deprange $PV $MAXKDEVER kde-base/kbabel)
	$(deprange $PV $MAXKDEVER kde-base/kbugbuster)
	$(deprange $PV $MAXKDEVER kde-base/kcachegrind)
	$(deprange $PV $MAXKDEVER kde-base/kdesdk-kfile-plugins)
	$(deprange $PV $MAXKDEVER kde-base/kdesdk-misc)
	$(deprange $PV $MAXKDEVER kde-base/kdesdk-scripts)
	$(deprange $PV $MAXKDEVER kde-base/kmtrace)
	$(deprange $PV $MAXKDEVER kde-base/kompare)
	$(deprange $PV $MAXKDEVER kde-base/kspy)
	$(deprange $PV $MAXKDEVER kde-base/kuiviewer)
	subversion? ( $(deprange $PV $MAXKDEVER kde-base/kdesdk-kioslaves) )
	$(deprange $PV $MAXKDEVER kde-base/umbrello)"
