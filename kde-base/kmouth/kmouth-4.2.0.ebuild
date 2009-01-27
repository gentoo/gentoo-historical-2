# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmouth/kmouth-4.2.0.ebuild,v 1.1 2009/01/27 17:28:13 alexxy Exp $

EAPI="2"

KMNAME="kdeaccessibility"
inherit kde4-meta

DESCRIPTION="KDE: A type-and-say front end for speech synthesizers"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

pkg_postinst() {
	kde4-meta_pkg_postinst
	elog "Suggested: kde-base/kttsd:${SLOT}"
}
