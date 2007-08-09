# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcoloredit/kcoloredit-3.5.7.ebuild,v 1.5 2007/08/09 19:34:35 corsair Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE color selector/editor"
KEYWORDS="alpha ~amd64 ia64 ppc ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""
