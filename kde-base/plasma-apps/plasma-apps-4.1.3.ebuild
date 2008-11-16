# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/plasma-apps/plasma-apps-4.1.3.ebuild,v 1.2 2008/11/16 08:25:46 vapier Exp $

EAPI="2"

KMNAME=kdebase
KMMODULE=apps/plasma
inherit kde4-meta

DESCRIPTION="Additional Applets for Plasma"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="!kde-base/plasma:${SLOT}
	kde-base/libplasma:${SLOT}
	kde-base/libkonq:${SLOT}"
