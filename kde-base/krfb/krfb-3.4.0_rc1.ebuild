# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krfb/krfb-3.4.0_rc1.ebuild,v 1.1 2005/02/27 20:21:39 danarmak Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="VNC-compatible server to share KDE desktops"
KEYWORDS="~x86"
IUSE="slp"
DEPEND="slp? ( net-libs/openslp )"

src_compile() {
	myconf="$myconf `use_enable slp`"
	kde-meta_src_compile
}