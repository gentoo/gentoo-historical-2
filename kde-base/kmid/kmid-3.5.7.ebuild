# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmid/kmid-3.5.7.ebuild,v 1.4 2007/08/08 18:42:52 armin76 Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE midi player"
KEYWORDS="alpha ~amd64 ia64 ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""
