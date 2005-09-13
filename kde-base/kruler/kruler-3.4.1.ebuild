# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kruler/kruler-3.4.1.ebuild,v 1.9 2005/09/13 13:40:17 agriffis Exp $

KMNAME=kdegraphics
MAXKDEVER=3.4.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="A screen ruler for the K Desktop Environment"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""