# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate/kate-3.5.5.ebuild,v 1.4 2006/11/14 15:52:04 gustavoz Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE MDI editor/ide"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

KMEXTRA="doc/kwrite"

