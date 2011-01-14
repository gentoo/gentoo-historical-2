# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koffice-meta/koffice-meta-2.3.0.ebuild,v 1.1 2011/01/14 20:38:15 dilfridge Exp $

EAPI=3

DESCRIPTION="KOffice - merge this to pull in all KOffice-derived packages"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2"

SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="nls reports"

RDEPEND="
	>=app-office/karbon-${PV}:${SLOT}
	>=app-office/kexi-${PV}:${SLOT}
	>=app-office/koffice-data-${PV}:${SLOT}
	>=app-office/koffice-libs-${PV}:${SLOT}[reports?]
	>=app-office/kpresenter-${PV}:${SLOT}
	>=app-office/krita-${PV}:${SLOT}
	>=app-office/kspread-${PV}:${SLOT}
	>=app-office/kword-${PV}:${SLOT}
	nls? ( >=app-office/koffice-l10n-${PV}:${SLOT} )
	reports? ( >=app-office/kplato-${PV}:${SLOT} )
	!app-office/kchart
"
