# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krdc/krdc-3.4.1.ebuild,v 1.8 2005/12/09 09:52:07 flameeyes Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE remote desktop connection (RDP and VNC) client"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="rdesktop slp"
DEPEND=">=dev-libs/openssl-0.9.6b
	slp? ( net-libs/openslp )"
RDEPEND="${DEPEND}
	rdesktop? ( >=net-misc/rdesktop-1.4.1 )"

src_compile() {
	myconf="$myconf `use_enable slp`"
	kde-meta_src_compile
}
