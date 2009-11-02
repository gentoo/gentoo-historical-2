# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/akregator/akregator-4.3.3.ebuild,v 1.1 2009/11/02 20:29:51 wired Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE news feed aggregator."
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook"

DEPEND="
	$(add_kdebase_dep libkdepim)
"
RDEPEND="${DEPEND}"

KMLOADLIBS="libkdepim"
