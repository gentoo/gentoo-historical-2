# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krfb/krfb-3.5.8.ebuild,v 1.2 2008/01/28 22:02:41 philantrop Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="VNC-compatible server to share KDE desktops"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility slp"
DEPEND="slp? ( net-libs/openslp )
	x11-libs/libXtst"

RDEPEND="${DEPEND}"

src_compile() {
	myconf="$myconf `use_enable slp`"
	kde-meta_src_compile
}
