# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kjots/kjots-3.5.2.ebuild,v 1.7 2006/05/29 22:14:23 weeve Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Kjots - KDE note taking utility"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""