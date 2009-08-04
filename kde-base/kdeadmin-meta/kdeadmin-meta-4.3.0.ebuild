# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin-meta/kdeadmin-meta-4.3.0.ebuild,v 1.3 2009/08/04 12:29:50 wired Exp $

EAPI="2"

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="cups kdeprefix lilo"

RDEPEND="
	>=kde-base/kcron-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/knetworkconf-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ksystemlog-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kuser-${PV}:${SLOT}[kdeprefix=]
	cups? ( >=kde-base/system-config-printer-kde-${PV}:${SLOT}[kdeprefix=] )
	lilo? ( >=kde-base/lilo-config-${PV}:${SLOT}[kdeprefix=] )
"

## The following package was just added and has a questionable interest to Gentoo
#	>=kde-base/kpackage-${PV}:${SLOT}

## the following packages are currently missing in kde 4.1
#>=kde-base/kdeadmin-kfile-plugins-${PV}:${SLOT}
#>=kde-base/secpolicy-${PV}:${SLOT}

## These seem to be broken
#>=kde-base/kdat-${PV}:${SLOT}
#>=kde-base/ksysv-${PV}:${SLOT}
