# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksnapshot/ksnapshot-3.4.1.ebuild,v 1.1.1.1 2005/11/30 10:13:29 chriswhite Exp $

KMNAME=kdegraphics
MAXKDEVER=3.4.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE Screenshot Utility"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

PATCHES="${FILESDIR}/${PN}-qt-3.3.5.patch"

