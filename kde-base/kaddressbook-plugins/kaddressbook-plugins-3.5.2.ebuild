# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kaddressbook-plugins/kaddressbook-plugins-3.5.2.ebuild,v 1.6 2006/05/29 21:06:07 weeve Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA=kaddressbook-plugins/
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Plugins for KAB"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 sparc x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kaddressbook)"

