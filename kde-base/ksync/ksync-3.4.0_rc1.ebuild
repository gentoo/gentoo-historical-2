# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksync/ksync-3.4.0_rc1.ebuild,v 1.2 2005/03/03 12:20:08 cryos Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE pda synchronizer"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)"
OLDDEPEND="~kde-base/libkcal-$PV"

KMCOPYLIB="
	libkcal libkcal"
KMEXTRACTONLY="
	libkcal/"
