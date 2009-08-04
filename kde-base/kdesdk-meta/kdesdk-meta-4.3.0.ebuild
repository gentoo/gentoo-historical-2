# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-meta/kdesdk-meta-4.3.0.ebuild,v 1.1 2009/08/04 00:23:01 wired Exp $

EAPI="2"

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
# FIXME:
# Add this back when adding kmtrace
# elibc_glibc
IUSE="kdeprefix"

RDEPEND="
	>=kde-base/cervisia-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kapptemplate-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kate-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kbugbuster-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kcachegrind-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeaccounts-plugin-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdesdk-kioslaves-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdesdk-misc-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdesdk-scripts-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdesdk-strigi-analyzer-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kompare-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kstartperf-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kuiviewer-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/lokalize-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/umbrello-${PV}:${SLOT}[kdeprefix=]
"

# FIXME:
# Broken in 4.1.0
#   >=kde-base/kspy-${PV}:${SLOT}
#	elibc_glibc? ( >=kde-base/kmtrace-${PV}:${SLOT} )
#	>=kde-base/kunittest-${PV}:${SLOT}
