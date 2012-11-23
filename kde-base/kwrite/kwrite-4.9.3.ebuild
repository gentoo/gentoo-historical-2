# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwrite/kwrite-4.9.3.ebuild,v 1.2 2012/11/23 17:51:15 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kate"
KMEXTRACTONLY="doc/kate"
inherit kde4-meta

DESCRIPTION="KDE MDI editor/IDE"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep katepart)
"
