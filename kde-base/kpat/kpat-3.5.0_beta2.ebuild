# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpat/kpat-3.5.0_beta2.ebuild,v 1.1 2005/10/14 18:41:57 danarmak Exp $
KMNAME=kdegames
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE patience game"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkdegames)"

RDEPEND="${DEPEND}
	$(deprange-dual $PV $MAXKDEVER kde-base/kdebase-data)"

KMEXTRACTONLY=libkdegames
KMCOPYLIB="libkdegames libkdegames"
