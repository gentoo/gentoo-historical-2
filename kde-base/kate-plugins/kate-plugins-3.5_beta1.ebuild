# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate-plugins/kate-plugins-3.5_beta1.ebuild,v 1.2 2005/10/22 06:28:34 halcy0n Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kate"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kate plugins and docs"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kate)"
OLDDEPEND="~kde-base/kate-$PV"
