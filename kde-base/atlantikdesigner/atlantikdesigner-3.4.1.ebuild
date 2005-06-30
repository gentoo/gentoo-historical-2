# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/atlantikdesigner/atlantikdesigner-3.4.1.ebuild,v 1.3 2005/06/30 21:02:20 danarmak Exp $
KMNAME=kdeaddons
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Atlantik gameboard designer"
KEYWORDS="x86 amd64 ~ppc64 ~ppc ~sparc"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/atlantik)"
OLDDEPEND="~kde-base/atlantik-$PV"


