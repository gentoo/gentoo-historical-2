# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork-meta/kdenetwork-meta-4.3.1.ebuild,v 1.3 2009/10/18 17:56:38 maekke Exp $

EAPI="2"
inherit kde4-functions

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.3"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="kdeprefix"

RDEPEND="
	>=kde-base/kdenetwork-filesharing-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdnssd-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kget-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kopete-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kppp-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/krdc-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/krfb-${PV}:${SLOT}[kdeprefix=]
	$(block_other_slots)
"
