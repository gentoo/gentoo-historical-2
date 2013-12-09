# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-meta/kdesdk-meta-4.11.2.ebuild,v 1.3 2013/12/09 05:44:50 ago Exp $

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="http://www.kde.org/applications/development"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="cvs"

RDEPEND="
	cvs? ( $(add_kdebase_dep cervisia) )
	$(add_kdebase_dep dolphin-plugins)
	$(add_kdebase_dep kapptemplate)
	$(add_kdebase_dep kate)
	$(add_kdebase_dep kcachegrind)
	$(add_kdebase_dep kde-dev-scripts)
	$(add_kdebase_dep kde-dev-utils)
	$(add_kdebase_dep kdesdk-kioslaves)
	$(add_kdebase_dep kompare)
	$(add_kdebase_dep lokalize)
	$(add_kdebase_dep okteta)
	$(add_kdebase_dep poxml)
	$(add_kdebase_dep umbrello)
"
