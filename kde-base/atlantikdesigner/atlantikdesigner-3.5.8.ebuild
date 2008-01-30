# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/atlantikdesigner/atlantikdesigner-3.5.8.ebuild,v 1.5 2008/01/30 17:22:43 ranger Exp $
KMNAME=kdeaddons
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Atlantik gameboard designer"
KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/atlantik)"
