# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate/kate-3.5.5-r1.ebuild,v 1.4 2007/01/31 04:20:22 josejx Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE MDI editor/ide"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

KMEXTRA="doc/kwrite"

PATCHES="${FILESDIR}/${P}-visibility.patch"
