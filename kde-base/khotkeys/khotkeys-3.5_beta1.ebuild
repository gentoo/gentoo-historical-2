# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khotkeys/khotkeys-3.5_beta1.ebuild,v 1.2 2005/10/09 18:01:43 betelgeuse Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: hotkey daemon"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES="${FILESDIR}/${PN}-qt-3.3.5.patch"
