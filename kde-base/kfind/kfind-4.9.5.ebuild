# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfind/kfind-4.9.5.ebuild,v 1.2 2013/01/27 12:09:55 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
inherit kde4-meta

DESCRIPTION="KDE file finder utility"
KEYWORDS="amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkonq)
"
RDEPEND="${DEPEND}"
