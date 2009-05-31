# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdetoys-meta/kdetoys-meta-3.5.10.ebuild,v 1.2 2009/05/31 21:41:12 nixnut Exp $

EAPI="1"
inherit kde-functions
DESCRIPTION="kdetoys - merge this to pull in all kdetoys-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
>=kde-base/amor-${PV}:${SLOT}
>=kde-base/eyesapplet-${PV}:${SLOT}
>=kde-base/fifteenapplet-${PV}:${SLOT}
>=kde-base/kmoon-${PV}:${SLOT}
>=kde-base/kodo-${PV}:${SLOT}
>=kde-base/kteatime-${PV}:${SLOT}
>=kde-base/ktux-${PV}:${SLOT}
>=kde-base/kweather-${PV}:${SLOT}
>=kde-base/kworldclock-${PV}:${SLOT}
"
