# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/eyesapplet/eyesapplet-3.5.5.ebuild,v 1.4 2006/11/14 14:52:36 gustavoz Exp $

KMNAME=kdetoys
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kicker applet: eyes following the movement of the mouse pointer"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=""