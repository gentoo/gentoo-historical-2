# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kompare/kompare-3.5.8.ebuild,v 1.7 2008/01/31 15:32:17 ranger Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: A program to view the differences between files and optionally generate a diff"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
