# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksim/ksim-3.5.2.ebuild,v 1.5 2006/05/25 23:35:02 wolf31o2 Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE System Monitor applets"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="snmp"
DEPEND="snmp? ( net-analyzer/net-snmp )"

myconf="$myconf $(use_with snmp)"

src_unpack() {
	kde-meta_src_unpack
	sed -i -e "s:Hidden=true:Hidden=false:" ksim/ksim.desktop
}