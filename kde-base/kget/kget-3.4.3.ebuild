# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kget/kget-3.4.3.ebuild,v 1.6 2005/12/10 07:01:20 chriswhite Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="An advanced download manager for KDE"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE=""
