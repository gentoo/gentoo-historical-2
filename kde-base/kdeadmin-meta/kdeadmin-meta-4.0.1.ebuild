# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin-meta/kdeadmin-meta-4.0.1.ebuild,v 1.2 2008/03/04 04:17:13 jer Exp $

EAPI="1"

inherit kde4-functions

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="kde-4"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="lilo"

RDEPEND="
	>=kde-base/kcron-${PV}:${SLOT}
	>=kde-base/knetworkconf-${PV}:${SLOT}
	>=kde-base/kuser-${PV}:${SLOT}
	>=kde-base/secpolicy-${PV}:${SLOT}
	lilo? ( >=kde-base/lilo-config-${PV}:${SLOT} )
"

## the following package has missing rdepends (the 'SMART package manager') and
## isn't useful enough on Gentoo to fix it now
#	>=kde-base/kpackage-${PV}:${SLOT}

## the following packages are currently missing in kde 4
#>=kde-base/kdat-${PV}:${SLOT}
#>=kde-base/ksysv-${PV}:${SLOT}
#>=kde-base/kdeadmin-kfile-plugins-${PV}:${SLOT}
