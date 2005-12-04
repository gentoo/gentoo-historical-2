# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kappfinder/kappfinder-3.5.0.ebuild,v 1.3 2005/12/04 10:26:29 kloeri Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE tool that looks for well-known apps in your path and creates .desktop files for them in the KDE menu"
KEYWORDS="~alpha ~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="$(deprange $PV $MAXKDEVER kde-base/kicker)"
