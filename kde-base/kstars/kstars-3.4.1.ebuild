# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kstars/kstars-3.4.1.ebuild,v 1.3 2005/06/30 21:02:26 danarmak Exp $
KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE Desktop Planetarium"
KEYWORDS="x86 amd64 ~ppc64 ~ppc ~sparc"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdeedu)"
OLDDEPEND="~kde-base/libkdeedu-$PV"

KMEXTRACTONLY="libkdeedu/extdate libkdeedu/kdeeduplot"
KMCOPYLIB="libextdate libkdeedu/extdate
	    libkdeeduplot libkdeedu/kdeeduplot"

src_unpack () {
	kde-meta_src_unpack
	cd $S
}
