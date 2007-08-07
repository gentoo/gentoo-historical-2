# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/networkstatus/networkstatus-3.5.7.ebuild,v 1.2 2007/08/07 19:56:17 gustavoz Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE network connection status tracking daemon"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""
