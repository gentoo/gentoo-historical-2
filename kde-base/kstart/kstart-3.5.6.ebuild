# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kstart/kstart-3.5.6.ebuild,v 1.7 2007/08/08 19:59:31 armin76 Exp $

KMNAME=kdebase
MAXKDEVER=3.5.7
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: Utility to launch applications with special window properties"
KEYWORDS="alpha ~amd64 ia64 ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
