# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kviewshell/kviewshell-3.5.6.ebuild,v 1.2 2007/04/07 14:35:27 carlo Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: Generic framework for viewer applications"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="$(deprange $PV $MAXKDEVER kde-base/kdebase-kioslaves)"