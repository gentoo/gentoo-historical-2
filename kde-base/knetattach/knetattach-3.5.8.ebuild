# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knetattach/knetattach-3.5.8.ebuild,v 1.5 2008/01/30 17:23:50 ranger Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE network wizard"
KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
