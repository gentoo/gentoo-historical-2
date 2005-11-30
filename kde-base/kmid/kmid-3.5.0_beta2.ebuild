# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmid/kmid-3.5.0_beta2.ebuild,v 1.1.1.1 2005/11/30 10:13:22 chriswhite Exp $

KMNAME=kdemultimedia
MAXKDEVER=3.5.0_rc1
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE midi player"
KEYWORDS="~amd64 ~x86"
IUSE=""