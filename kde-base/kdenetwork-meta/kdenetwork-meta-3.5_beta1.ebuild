# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork-meta/kdenetwork-meta-3.5_beta1.ebuild,v 1.2 2005/10/22 06:48:45 halcy0n Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~amd64 ~x86"
IUSE="wifi"

RDEPEND="$(deprange $PV $MAXKDEVER kde-base/dcoprss)
	$(deprange $PV $MAXKDEVER kde-base/kdenetwork-filesharing)
	$(deprange $PV $MAXKDEVER kde-base/kdict)
	$(deprange $PV $MAXKDEVER kde-base/kget)
	$(deprange $PV $MAXKDEVER kde-base/knewsticker)
	$(deprange $PV $MAXKDEVER kde-base/kopete)
	$(deprange $PV $MAXKDEVER kde-base/kpf)
	$(deprange $PV $MAXKDEVER kde-base/kppp)
	$(deprange $PV $MAXKDEVER kde-base/krdc)
	$(deprange $PV $MAXKDEVER kde-base/krfb)
	$(deprange $PV $MAXKDEVER kde-base/ksirc)
	$(deprange $PV $MAXKDEVER kde-base/ktalkd)
	wifi? ( $(deprange $PV $MAXKDEVER kde-base/kwifimanager) )
	$(deprange $PV $MAXKDEVER kde-base/librss)
	$(deprange $PV $MAXKDEVER kde-base/kdnssd)
	$(deprange $PV $MAXKDEVER kde-base/kdenetwork-kfile-plugins)
	$(deprange $PV $MAXKDEVER kde-base/lisa)"
