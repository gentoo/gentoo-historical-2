# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwifimanager/kwifimanager-3.5.5.ebuild,v 1.4 2006/11/16 04:34:00 josejx Exp $

KMNAME=kdenetwork
KMMODULE=wifi
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE wifi (wireless network) gui"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""
DEPEND="net-wireless/wireless-tools"

RDEPEND="${DEPEND}"

KMEXTRA="doc/kwifimanager"

