# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeprint/kdeprint-3.4.0_beta1.ebuild,v 1.1 2005/01/15 02:24:31 danarmak Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE printer queue/device manager"
KEYWORDS="~x86"
IUSE="cups"

DEPEND="cups? ( net-print/cups )"

src_compile() {
	myconf="$myconf `use_with cups`"
	kde-meta_src_compile
}
