# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcron/kcron-3.4.3.ebuild,v 1.7 2005/12/10 05:40:14 chriswhite Exp $
KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE Task Scheduler"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/cron"
