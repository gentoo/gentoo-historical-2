# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesu/kdesu-3.5.5.ebuild,v 1.1 2006/10/03 10:23:06 flameeyes Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils flag-o-matic

SRC_URI="${SRC_URI}
	mirror://gentoo/kdebase-3.5-patchset-01.tar.bz2"

DESCRIPTION="KDE: gui for su(1)"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

src_compile() {
	export BINDNOW_FLAGS="$(bindnow-flags)"

	kde-meta_src_compile
}
