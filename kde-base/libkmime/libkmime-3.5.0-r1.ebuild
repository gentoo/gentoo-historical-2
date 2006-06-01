# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkmime/libkmime-3.5.0-r1.ebuild,v 1.7 2006/06/01 04:59:24 tcort Exp $

KMNAME=kdepim

MAXKDEVER=3.5.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE kmime library for Message Handling"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""


PATCHES="${FILESDIR}/libkmime-3.5.0-fix.diff"