# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate-plugins/kate-plugins-3.4.3.ebuild,v 1.8 2006/03/27 15:20:05 agriffis Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kate"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kate plugins and docs"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kate)"
OLDDEPEND="~kde-base/kate-$PV"
