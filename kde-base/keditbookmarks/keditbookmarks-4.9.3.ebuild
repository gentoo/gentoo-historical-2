# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/keditbookmarks/keditbookmarks-4.9.3.ebuild,v 1.2 2012/11/23 17:21:25 ago Exp $

EAPI=4

KMNAME="kde-baseapps"
VIRTUALX_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="KDE's bookmarks editor"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkonq)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	lib/konq/
"
