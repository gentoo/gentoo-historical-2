# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/epbb/epbb-0.0.5.20040201.ebuild,v 1.2 2004/03/16 04:53:51 warpzero Exp $

inherit enlightenment

DESCRIPTION="a pbbuttonsd client using the EFL"

KEYWORDS="~ppc"

DEPEND=">=x11-libs/evas-1.0.0.20040117_pre12
	>=media-libs/edje-0.0.1.20040117
	>=x11-libs/ecore-1.0.0.20040117_pre4
	>=app-laptop/pbbuttonsd-0.5.2"
