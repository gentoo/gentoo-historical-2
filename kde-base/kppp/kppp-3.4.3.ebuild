# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kppp/kppp-3.4.3.ebuild,v 1.8 2006/03/25 02:01:59 agriffis Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: A dialer and front-end to pppd"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""
