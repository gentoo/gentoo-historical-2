# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-sounds/kdeartwork-sounds-3.5.0.ebuild,v 1.2 2005/11/29 04:42:15 weeve Exp $

KMMODULE=sounds
KMNAME=kdeartwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Extra sound themes for kde"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""
DEPEND=""
