# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-meta/kdesdk-meta-4.4.5.ebuild,v 1.5 2010/08/09 17:33:44 scarabeus Exp $

EAPI="3"
inherit kde4-functions

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.4"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="aqua kdeprefix"

RDEPEND="
	$(add_kdebase_dep cervisia)
	$(add_kdebase_dep kapptemplate)
	$(add_kdebase_dep kate)
	$(add_kdebase_dep kbugbuster)
	$(add_kdebase_dep kcachegrind)
	$(add_kdebase_dep kdeaccounts-plugin)
	$(add_kdebase_dep kdesdk-kioslaves)
	$(add_kdebase_dep kdesdk-misc)
	$(add_kdebase_dep kdesdk-scripts)
	$(add_kdebase_dep kdesdk-strigi-analyzer)
	$(add_kdebase_dep kompare)
	$(add_kdebase_dep kstartperf)
	$(add_kdebase_dep kuiviewer)
	$(add_kdebase_dep lokalize)
	$(add_kdebase_dep umbrello)
	$(block_other_slots)
"
