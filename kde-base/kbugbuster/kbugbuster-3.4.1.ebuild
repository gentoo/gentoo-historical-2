# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kbugbuster/kbugbuster-3.4.1.ebuild,v 1.3 2005/06/30 21:02:21 danarmak Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KBugBuster - A tool for checking and reporting KDE apps' bugs"
KEYWORDS="x86 amd64 ~ppc64 ~ppc ~sparc"
IUSE="kcal"

OLDDEPEND="kcal? ( ~kde-base/libkcal-$PV )"
DEPEND="kcal? ( $(deprange $PV $MAXKDEVER kde-base/libkcal) )"

#TODO tell configure about the optional kcal support, or something
