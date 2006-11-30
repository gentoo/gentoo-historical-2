# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krdc/krdc-3.5.5.ebuild,v 1.7 2006/11/30 08:12:31 corsair Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE remote desktop connection (RDP and VNC) client"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="rdesktop slp"
DEPEND=">=dev-libs/openssl-0.9.6b
	slp? ( net-libs/openslp )
	x11-libs/libXxf86vm
	x11-libs/libXtst"
RDEPEND="${DEPEND}
	rdesktop? ( >=net-misc/rdesktop-1.4.1 )"

src_compile() {
	myconf="$myconf `use_enable slp`"
	kde-meta_src_compile
}
