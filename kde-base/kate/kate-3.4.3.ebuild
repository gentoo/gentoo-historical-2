# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate/kate-3.4.3.ebuild,v 1.4 2005/11/24 22:12:26 cryos Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE MDI editor/ide"
KEYWORDS="~alpha amd64 ~ppc ppc64 sparc ~x86"
IUSE=""

KMEXTRA="doc/kwrite"

