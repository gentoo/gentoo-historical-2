# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/epbb/epbb-0.0.5.20040201.ebuild,v 1.2 2005/01/01 14:45:43 eradicator Exp $

inherit enlightenment

DESCRIPTION="a pbbuttonsd client using the EFL"

KEYWORDS="~ppc"

DEPEND=">=x11-libs/evas-1.0.0_pre13
	>=media-libs/edje-0.5.0
	>=x11-libs/ecore-1.0.0_pre7
	>=app-laptop/pbbuttonsd-0.5.2"
