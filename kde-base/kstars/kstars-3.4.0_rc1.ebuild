# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kstars/kstars-3.4.0_rc1.ebuild,v 1.2 2005/03/13 02:00:40 cryos Exp $
KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE Desktop Planetarium"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="$(deprange 3.4.0_beta2 $MAXKDEVER kde-base/libkdeedu)"
OLDDEPEND="~kde-base/libkdeedu-$PV"

KMEXTRACTONLY="libkdeedu/extdate libkdeedu/kdeeduplot"
KMCOPYLIB="libextdate libkdeedu/extdate
	    libkdeeduplot libkdeedu/kdeeduplot"

src_unpack () {
	kde-meta_src_unpack
	cd $S
	use sparc && epatch "$FILESDIR/kdeedu-sparc.patch"
	use ppc && epatch "$FILESDIR/kdeedu-sparc.patch"
	use ppc64 && epatch "$FILESDIR/kdeedu-sparc.patch"
}
