# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krfb/krfb-3.4.3.ebuild,v 1.2 2005/11/24 13:59:07 gustavoz Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="VNC-compatible server to share KDE desktops"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 sparc ~x86"
IUSE="slp"
DEPEND="slp? ( net-libs/openslp )"

src_compile() {
	myconf="$myconf `use_enable slp`"
	kde-meta_src_compile
}
