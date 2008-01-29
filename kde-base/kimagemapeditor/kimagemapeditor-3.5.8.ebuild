# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kimagemapeditor/kimagemapeditor-3.5.8.ebuild,v 1.3 2008/01/29 15:38:31 armin76 Exp $
KMNAME=kdewebdev
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE: An HTML imagemap editor"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
