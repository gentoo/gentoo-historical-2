# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ktux/ktux-3.5.5.ebuild,v 1.8 2006/12/06 14:29:53 kloeri Exp $

KMNAME=kdetoys
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE: screensaver featuring the Space-Faring Tux"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
DEPEND=""