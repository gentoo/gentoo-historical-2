# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/plasma-apps/plasma-apps-4.2.1.ebuild,v 1.1 2009/03/04 22:51:51 alexxy Exp $

EAPI="2"

KMNAME="kdebase"
KMMODULE="apps/plasma"
inherit kde4-meta

DESCRIPTION="Additional Applets for Plasma"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND="!kde-base/plasma:${SLOT}
	kde-base/libkonq:${SLOT}"
