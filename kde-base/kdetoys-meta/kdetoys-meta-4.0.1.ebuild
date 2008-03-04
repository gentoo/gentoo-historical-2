# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdetoys-meta/kdetoys-meta-4.0.1.ebuild,v 1.2 2008/03/04 03:56:51 jer Exp $

EAPI="1"

inherit kde4-functions

DESCRIPTION="KDE toys - merge this to pull in all kdetoys-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="kde-4"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

RDEPEND="
	>=kde-base/amor-${PV}:${SLOT}
	>=kde-base/kteatime-${PV}:${SLOT}
	>=kde-base/ktux-${PV}:${SLOT}
	>=kde-base/kweather-${PV}:${SLOT}
	>=kde-base/kworldclock-${PV}:${SLOT}
"

# Disabled by upstream in 4.0.1
#>=kde-base/eyesapplet-${PV}:${SLOT}
#>=kde-base/fifteenapplet-${PV}:${SLOT}
#>=kde-base/kmoon-${PV}:${SLOT}
