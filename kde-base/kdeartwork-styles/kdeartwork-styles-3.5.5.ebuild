# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-styles/kdeartwork-styles-3.5.5.ebuild,v 1.6 2006/11/26 22:52:32 corsair Exp $

KMMODULE=styles
KMNAME=kdeartwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Extra styles for kde"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=""
