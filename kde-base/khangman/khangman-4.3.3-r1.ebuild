# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khangman/khangman-4.3.3-r1.ebuild,v 1.6 2010/01/19 00:43:14 jer Exp $

EAPI="2"

KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="Classical hangman game for KDE"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="debug +handbook"

DEPEND="
	$(add_kdebase_dep libkdeedu)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kvtml-data)
"

KMEXTRACTONLY="
	libkdeedu/keduvocdocument
"
