# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khotkeys/khotkeys-3.4.1.ebuild,v 1.5 2005/07/02 01:28:30 pylon Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: hotkey daemon"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""


