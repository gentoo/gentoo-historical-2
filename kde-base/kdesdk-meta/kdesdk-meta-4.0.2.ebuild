# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-meta/kdesdk-meta-4.0.2.ebuild,v 1.1 2008/03/10 23:35:14 philantrop Exp $

EAPI="1"

inherit kde4-functions

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="kde-4"
KEYWORDS="~amd64 ~x86"
# FIXME:
# Add this back when adding kmtrace
# elibc_glibc
IUSE=""

RDEPEND="
	>=kde-base/kapptemplate-${PV}:${SLOT}
	>=kde-base/kate-${PV}:${SLOT}
	>=kde-base/kbugbuster-${PV}:${SLOT}
	>=kde-base/cervisia-${PV}:${SLOT}
	>=kde-base/kcachegrind-${PV}:${SLOT}
	>=kde-base/kdesdk-kioslaves-${PV}:${SLOT}
	>=kde-base/kdesdk-misc-${PV}:${SLOT}
	>=kde-base/kdesdk-scripts-${PV}:${SLOT}
	>=kde-base/kuiviewer-${PV}:${SLOT}
	>=kde-base/umbrello-${PV}:${SLOT}
	>=kde-base/kdeaccounts-plugin-${PV}:${SLOT}
	>=kde-base/kompare-${PV}:${SLOT}
	>=kde-base/strigi-analyzer-${PV}:${SLOT}
"

# FIXME:
# Broken in 4.0.2:
#   >=kde-base/kspy-${PV}:${SLOT}
#	elibc_glibc? ( >=kde-base/kmtrace-${PV}:${SLOT} )
#	>=kde-base/kunittest-${PV}:${SLOT}

# this compiles and installs fine but gives illegal instructions at run time:
#	>=kde-base/kstartperf-${PV}:${SLOT}
#	>=kde-base/kdesdk-kfile-plugins-${PV}:${SLOT}
