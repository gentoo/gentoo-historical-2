# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate-plugins/kate-plugins-3.4.0_beta1.ebuild,v 1.2 2005/02/11 19:11:32 caleb Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kate doc/kate-plugins"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kate plugins and docs"
KEYWORDS="~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kate)"
OLDDEPEND="~kde-base/kate-$PV"
