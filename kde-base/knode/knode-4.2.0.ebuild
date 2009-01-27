# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knode/knode-4.2.0.ebuild,v 1.1 2009/01/27 17:31:28 alexxy Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="A newsreader for KDE"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND=">=kde-base/libkdepim-${PV}:${SLOT}
	>=kde-base/libkpgp-${PV}:${SLOT}"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="libkdepim/
	libkpgp/"
	#kaddressbook/org.kde.KAddressbook.Core.xml
	#korganizer/korgac/org.kde.korganizer.KOrgac.xml"

KMLOADLIBS="libkdepim"
