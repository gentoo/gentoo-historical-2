# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khangman/khangman-3.5.2.ebuild,v 1.4 2006/05/26 17:05:06 corsair Exp $
KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Classical hangman game for KDE"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ppc64 ~sparc x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdeedu)"


KMEXTRACTONLY="libkdeedu/kdeeducore"
KMCOPYLIB="libkdeeducore libkdeedu/kdeeducore"
