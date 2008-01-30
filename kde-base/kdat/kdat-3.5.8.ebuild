# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdat/kdat-3.5.8.ebuild,v 1.4 2008/01/30 17:23:24 ranger Exp $
KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="tar-based DAT archiver for KDE"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 ~sparc x86"
IUSE="kdehiddenvisibility"
DEPEND=""
