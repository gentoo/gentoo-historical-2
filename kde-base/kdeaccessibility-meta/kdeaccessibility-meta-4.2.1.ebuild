# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaccessibility-meta/kdeaccessibility-meta-4.2.1.ebuild,v 1.2 2009/04/11 19:48:24 armin76 Exp $

EAPI="2"

inherit kde4-functions

DESCRIPTION="kdeaccessibility - merge this to pull in all kdeaccessiblity-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	>=kde-base/kdeaccessibility-colorschemes-${PV}:${SLOT}
	>=kde-base/kdeaccessibility-iconthemes-${PV}:${SLOT}
	>=kde-base/kmag-${PV}:${SLOT}
	>=kde-base/kmousetool-${PV}:${SLOT}
	>=kde-base/kmouth-${PV}:${SLOT}
	>=kde-base/kttsd-${PV}:${SLOT}
"
# The following are disabled in CMakeLists.txt
# >=kde-base/kbstateapplet-${PV}:${SLOT} - kicker applet
# >=kde-base/ksayit-${PV}:${SLOT} - doesn't compile
