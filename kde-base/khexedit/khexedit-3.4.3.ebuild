# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khexedit/khexedit-3.4.3.ebuild,v 1.7 2005/12/10 20:12:22 kloeri Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE hex editor"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

PATCHES="$FILESDIR/khexedit-configure-magic.diff"
