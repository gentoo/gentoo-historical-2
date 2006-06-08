# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kompare/kompare-3.5.1.ebuild,v 1.10 2006/06/08 14:03:29 flameeyes Exp $

KMNAME=kdesdk
MAXKDEVER=3.5.3
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: A program to view the differences between files and optionally generate a diff"
KEYWORDS="alpha amd64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""