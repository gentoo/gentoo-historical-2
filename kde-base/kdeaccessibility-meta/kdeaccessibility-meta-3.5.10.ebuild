# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaccessibility-meta/kdeaccessibility-meta-3.5.10.ebuild,v 1.6 2009/07/12 13:37:30 armin76 Exp $

EAPI="1"
inherit kde-functions
DESCRIPTION="kdeaccessibility - merge this to pull in all kdeaccessiblity-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="arts"

RDEPEND="
arts? ( >=kde-base/ksayit-${PV}:${SLOT}
	>=kde-base/kttsd-${PV}:${SLOT} )
>=kde-base/kmag-${PV}:${SLOT}
>=kde-base/kdeaccessibility-iconthemes-${PV}:${SLOT}
>=kde-base/kmousetool-${PV}:${SLOT}
>=kde-base/kbstateapplet-${PV}:${SLOT}
>=kde-base/kmouth-${PV}:${SLOT}"
