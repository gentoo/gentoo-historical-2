# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksirtet/ksirtet-3.4.0_rc1.ebuild,v 1.1 2005/02/27 20:21:40 danarmak Exp $
KMNAME=kdegames
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KSirtet is an adaptation of the well-known Tetris game"
KEYWORDS="~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdegames)"
OLDDEPEND="~kde-base/libkdegames-$PV"

KMEXTRACTONLY=libkdegames
KMCOMPILEONLY=libksirtet
KMCOPYLIB="libkdegames libkdegames"
