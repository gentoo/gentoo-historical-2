# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpf/kpf-3.4.2.ebuild,v 1.6 2005/11/25 10:16:28 cryos Exp $

KMNAME=kdenetwork
MAXKDEVER=3.4.3
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Kicker file server (http) applet"
KEYWORDS="~alpha amd64 ~ppc ppc64 sparc ~x86"
IUSE=""
