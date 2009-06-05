# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmouth/kmouth-4.2.4.ebuild,v 1.2 2009/06/05 00:12:57 alexxy Exp $

EAPI="2"

KMNAME="kdeaccessibility"
inherit kde4-meta

DESCRIPTION="KDE: A type-and-say front end for speech synthesizers"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook"

pkg_postinst() {
	kde4-meta_pkg_postinst

	echo
	elog "Suggested: kde-base/kttsd:${SLOT}"
	echo
}
