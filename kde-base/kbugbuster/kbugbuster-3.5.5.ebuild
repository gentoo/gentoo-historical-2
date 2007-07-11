# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kbugbuster/kbugbuster-3.5.5.ebuild,v 1.9 2007/07/11 01:08:47 mr_bones_ Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KBugBuster - A tool for checking and reporting KDE apps' bugs"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kcal kdehiddenvisibility"

DEPEND="kcal? ( $(deprange $PV $MAXKDEVER kde-base/libkcal) )"

#TODO tell configure about the optional kcal support, or something
