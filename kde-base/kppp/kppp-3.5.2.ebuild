# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kppp/kppp-3.5.2.ebuild,v 1.4 2006/05/25 23:26:46 wolf31o2 Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils flag-o-matic

DESCRIPTION="KDE: A dialer and front-end to pppd"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

PATCHES="${FILESDIR}/${PN}-3.5.0-bindnow.patch"

src_compile() {
	export BINDNOW_FLAGS="$(bindnow-flags)"
	kde-meta_src_compile
}
