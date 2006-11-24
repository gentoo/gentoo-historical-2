# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kompare/kompare-3.5.5.ebuild,v 1.6 2006/11/24 14:02:21 gmsoft Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: A program to view the differences between files and optionally generate a diff"
KEYWORDS="~alpha amd64 hppa ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""