# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kview/kview-3.5.7.ebuild,v 1.3 2007/08/07 21:51:26 josejx Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kde image viwer"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""
