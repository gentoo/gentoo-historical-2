# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfilereplace/kfilereplace-3.4.3.ebuild,v 1.2 2005/11/24 14:58:17 gustavoz Exp $
KMNAME=kdewebdev
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE batch search&replace tool"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 sparc ~x86"
IUSE=""
