# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/akregator/akregator-3.4.0_rc1.ebuild,v 1.2 2005/03/03 12:00:03 cryos Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE news feed aggregator"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/kontact)
!net-www/akregator"

KMCOPYLIB="libkdepim libkdepim
libkpinterfaces kontact/interfaces"
KMEXTRACTONLY="libkdepim
kontact/interfaces"
KMEXTRA="kontact/plugins/akregator"
