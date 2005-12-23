# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xfindproxy/xfindproxy-1.0.1.ebuild,v 1.1 2005/12/23 10:37:44 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xfindproxy application"
KEYWORDS="~x86"
RDEPEND="x11-libs/libX11
	x11-libs/libICE
	x11-libs/libXt"
DEPEND="${RDEPEND}"
