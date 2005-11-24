# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwifimanager/kwifimanager-3.4.3.ebuild,v 1.2 2005/11/24 19:44:04 corsair Exp $

KMNAME=kdenetwork
KMMODULE=wifi
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE wifi (wireless network) gui"
KEYWORDS="~amd64 ~ppc ppc64 ~x86"
IUSE=""
DEPEND="net-wireless/wireless-tools"
KMEXTRA="doc/kwifimanager"

