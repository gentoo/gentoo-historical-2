# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpat/kpat-3.5.2.ebuild,v 1.4 2006/05/26 15:43:38 wolf31o2 Exp $
KMNAME=kdegames
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE patience game"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND="
$(deprange 3.5.1 $MAXKDEVER kde-base/libkdegames)"

RDEPEND="${DEPEND}
	$(deprange-dual $PV $MAXKDEVER kde-base/kdebase-data)"

KMEXTRACTONLY=libkdegames
KMCOPYLIB="libkdegames libkdegames"
