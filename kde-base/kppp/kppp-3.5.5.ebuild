# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kppp/kppp-3.5.5.ebuild,v 1.4 2006/11/14 15:06:18 gustavoz Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils flag-o-matic

SRC_URI="${SRC_URI}
	mirror://gentoo/kdenetwork-3.5-patchset-01.tar.bz2"

DESCRIPTION="KDE: A dialer and front-end to pppd."
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

src_compile() {
	export BINDNOW_FLAGS="$(bindnow-flags)"
	kde-meta_src_compile
}
