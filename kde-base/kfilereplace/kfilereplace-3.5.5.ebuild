# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfilereplace/kfilereplace-3.5.5.ebuild,v 1.9 2006/12/11 13:47:31 kloeri Exp $
KMNAME=kdewebdev
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE batch search&replace tool"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
