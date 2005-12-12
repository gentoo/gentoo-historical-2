# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksync/ksync-3.5.0.ebuild,v 1.4 2005/12/12 16:25:44 josejx Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE pda synchronizer"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)"


KMCOPYLIB="
	libkcal libkcal"
KMEXTRACTONLY="
	libkcal/"
