# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kimagemapeditor/kimagemapeditor-3.5.7.ebuild,v 1.5 2007/08/09 17:42:30 corsair Exp $
KMNAME=kdewebdev
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE: An HTML imagemap editor"
KEYWORDS="alpha ~amd64 ia64 ppc ppc64 sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
