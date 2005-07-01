# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khexedit/khexedit-3.4.1.ebuild,v 1.4 2005/07/01 14:45:27 corsair Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE hex editor"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"
IUSE=""

PATCHES="$FILESDIR/khexedit-configure-magic.diff"