# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ktnef/ktnef-3.5.2.ebuild,v 1.4 2006/05/26 16:32:19 corsair Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE Viewer for mail attachments using TNEF format"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ppc64 ~sparc x86"
IUSE=""

