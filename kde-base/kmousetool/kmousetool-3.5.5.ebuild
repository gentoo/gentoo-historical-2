# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmousetool/kmousetool-3.5.5.ebuild,v 1.4 2006/11/14 18:33:38 gustavoz Exp $
KMNAME=kdeaccessibility
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE accessibility tool: translates mouse hovering into clicks"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE=""
