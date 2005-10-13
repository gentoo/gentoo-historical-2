# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-meta/kdepim-meta-3.4.3.ebuild,v 1.1 2005/10/13 00:09:54 danarmak Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.4"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="pda"

RDEPEND="
	$(deprange $PV $MAXKDEVER kde-base/certmanager)
	$(deprange $PV $MAXKDEVER kde-base/kaddressbook)
	$(deprange $PV $MAXKDEVER kde-base/kalarm)
	$(deprange $PV $MAXKDEVER kde-base/kandy)
	$(deprange $PV $MAXKDEVER kde-base/karm)
	$(deprange $PV $MAXKDEVER kde-base/kdepim-kioslaves)
	$(deprange $PV $MAXKDEVER kde-base/kdepim-kresources)
	$(deprange $PV $MAXKDEVER kde-base/kdepim-wizards)
	$(deprange $PV $MAXKDEVER kde-base/kitchensync)
	$(deprange $PV $MAXKDEVER kde-base/kmail)
	$(deprange $PV $MAXKDEVER kde-base/kmailcvt)
	$(deprange $PV $MAXKDEVER kde-base/knode)
	$(deprange $PV $MAXKDEVER kde-base/knotes)
	$(deprange $PV $MAXKDEVER kde-base/kode)
	$(deprange $PV $MAXKDEVER kde-base/konsolekalendar)
	$(deprange $PV $MAXKDEVER kde-base/kontact)
	$(deprange $PV $MAXKDEVER kde-base/kontact-specialdates)
	$(deprange $PV $MAXKDEVER kde-base/korganizer)
	$(deprange $PV $MAXKDEVER kde-base/korn)
	pda? ( $(deprange $PV $MAXKDEVER kde-base/kpilot) )
	$(deprange $PV $MAXKDEVER kde-base/ksync)
	$(deprange $PV $MAXKDEVER kde-base/ktnef)
	$(deprange $PV $MAXKDEVER kde-base/libkcal)
	$(deprange 3.4.1 $MAXKDEVER kde-base/libkdenetwork)
	$(deprange $PV $MAXKDEVER kde-base/libkdepim)
	$(deprange $PV $MAXKDEVER kde-base/libkholidays)
	$(deprange 3.4.1 $MAXKDEVER kde-base/libkmime)
	$(deprange 3.4.1 $MAXKDEVER kde-base/libkpgp)
	$(deprange $PV $MAXKDEVER kde-base/libkpimexchange)
	$(deprange $PV $MAXKDEVER kde-base/libkpimidentities)
	$(deprange 3.4.1 $MAXKDEVER kde-base/libksieve)
	$(deprange 3.4.2 $MAXKDEVER kde-base/mimelib)
	$(deprange 3.4.2 $MAXKDEVER kde-base/networkstatus)"

# not compiled by default
#	$(deprange $PV $MAXKDEVER kde-base/kmobile)
